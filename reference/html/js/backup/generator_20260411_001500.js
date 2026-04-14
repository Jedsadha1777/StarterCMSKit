const DartGenerator = {
  generate(ast, _options = {}) {
    const context = {
      indent: '                ',
      controllers: new Map(),
      dropdowns: new Map(),
      checkboxes: new Map(),
      customWidgets: new Set(),
      usesGesture: false,
      usesTable: false,
      usesDiagonalBorder: false,
      usesComment: false,
      usesFormWidgets: false,
      bodyStyles: null,
    };

    if (ast.bodyStyles) context.bodyStyles = ast.bodyStyles;

    // Split document at top-level <pagebreak> tags into separate page ASTs.
    const pageAsts = this._splitPages(ast);
    const widgetCodes = pageAsts.map(pageAst => {
      const code = this.generateNode(pageAst, context);
      return 'child: ' + code.trimStart();
    });
    const widgetCode = widgetCodes[0];

    const controllersCode  = this.generateControllers(context);
    const importsCode      = this.generateImports(context);
    const stateCode        = this.generateStateVariables(context);
    const boilerplateCode  = this.generateBoilerplate(context, widgetCodes.join('\n'));

    return {
      widgetCode,
      widgetCodes,
      controllersCode,
      importsCode,
      stateCode,
      boilerplateCode,
      controllers:  context.controllers,
      dropdowns:    context.dropdowns,
      checkboxes:   context.checkboxes,
      usesTable:    context.usesTable,
    };
  },

  // Split ast.children at <pagebreak> elements into separate pseudo-document objects.
  // Because browsers treat <pagebreak> as an unknown inline element, multiple <pagebreak>
  // tags get nested inside each other. We walk recursively so N pagebreaks → N+1 pages.
  _splitPages(ast) {
    const segments = [];
    let current = [];

    const walk = (children) => {
      for (const child of children) {
        if (child.type === 'element' && child.tagName === 'pagebreak') {
          segments.push(current);
          current = [];
          walk(child.children || []); // recurse: next pagebreak may be nested inside
        } else {
          current.push(child);
        }
      }
    };

    walk(ast.children);
    segments.push(current);

    return segments
      .filter(s => s.some(c => c.type !== 'text' || c.content?.trim()))
      .map(children => ({ ...ast, children }));
  },

  generateNode(node, context) {
    if (!node) return 'const SizedBox.shrink()';
    switch (node.type) {
      case 'document':    return this.generateDocument(node, context);
      case 'text':        return this.generateText(node, context);
      case 'table':       return this.generateTable(node, context);
      case 'svg':         return '';
      case 'tr': case 'td': case 'th':
      case 'thead': case 'tbody': case 'tfoot':
      case 'colgroup': case 'col': case 'caption':
        return '';
      case 'input':       return this.generateInput(node, context);
      case 'select':      return this.generateSelect(node, context);
      case 'textarea':    return this.generateTextArea(node, context);
      case 'date-picker': return this.generateDatePicker(node, context);
      case 'signature':   return this.generateSignature(node, context);
      case 'image-upload':return this.generateImageUpload(node, context);
      case 'checkbox':    return this.generateCheckbox(node, context);
      case 'radio':       return this.generateRadio(node, context);
      case 'file':        return this.generateFile(node, context);
      case 'search':      return this.generateSearch(node, context);
      case 'option':      return '';
      case 'element':     return this.generateElement(node, context);
      default:            return this.generateChildren(node, context);
    }
  },

  generateDocument(node, context) {
    const children = node.children
      .map(c => this.generateNode(c, context))
      .filter(c => c && c.trim());
    if (children.length === 0) return 'const SizedBox.shrink()';
    if (children.length === 1) return children[0];
    const ind = context.indent;
    return `Column(
${ind}crossAxisAlignment: CrossAxisAlignment.start,
${ind}children: [
${children.map(c => `${ind}  ${c},`).join('\n')}
${ind}],
)`;
  },

  generateChildren(node, context) {
    if (!node.children || node.children.length === 0) return 'const SizedBox.shrink()';

    const visibleChildren = this._visibleChildren(node);

    const children = visibleChildren
      .map(c => this.generateNode(c, context))
      .filter(c => c && c.trim());

    if (children.length === 0) return 'const SizedBox.shrink()';
    if (children.length === 1) return children[0];

    const ind = context.indent;
    return `Column(
${ind}crossAxisAlignment: CrossAxisAlignment.start,
${ind}mainAxisSize: MainAxisSize.min,
${ind}children: [
${children.map(c => `${ind}  ${c},`).join('\n')}
${ind}],
)`;
  },

  generateText(node, _context) {
    const text = node.content.trim();
    if (!text) return '';
    return `Text('${this.escapeString(text)}')`;
  },

  _visibleChildren(node) {
    return (node.children || []).filter(c =>
      c.type !== 'svg' && c.styles?.position !== 'absolute'
    );
  },

  hasMixedInlineContent(node) {
    if (!node.children) return false;
    const visible = this._visibleChildren(node);
    const hasText  = visible.some(c => c.type === 'text' && c.content.trim());
    const hasSpan  = visible.some(c =>
      ['span','a','b','strong','i','em','u','s','strike','del','mark','sub','sup'].includes(c.tagName)
    );
    return hasText || hasSpan;
  },

  generateInlineContent(node, context) {
    const visible = this._visibleChildren(node);

    const spans = [];
    for (const child of visible) {
      if (child.type === 'text') {
        const t = child.content;
        if (t) spans.push(`TextSpan(text: '${this.escapeString(t)}')`);
        continue;
      }
      if (child.tagName === 'a') {
        const text = this.extractAllText(child);
        if (!text) continue;
        const href = child.attributes?.href || '#';
        context.usesGesture = true;
        spans.push(`TextSpan(text: '${this.escapeString(text)}', style: const TextStyle(color: Color(0xFF1976D2), decoration: TextDecoration.underline), recognizer: TapGestureRecognizer()..onTap = () { /* ${this.escapeString(href)} */ })`);
        continue;
      }
      const inlineTags = ['span','b','strong','i','em','u','s','strike','del','mark','code','sub','sup'];
      if (inlineTags.includes(child.tagName)) {
        if (this.hasMixedInlineContent(child)) {
          const nestedSpans = this.collectTextSpans(child, context);
          spans.push(...nestedSpans);
        } else {
          const text = this.extractAllText(child);
          if (!text) continue;
          const sp = this.buildTextSpanStyle(child.styles || {}, child.tagName);
          if (sp) {
            spans.push(`TextSpan(text: '${this.escapeString(text)}', style: TextStyle(${sp}))`);
          } else {
            spans.push(`TextSpan(text: '${this.escapeString(text)}')`);
          }
        }
        continue;
      }
      const text = this.extractAllText(child);
      if (text.trim()) spans.push(`TextSpan(text: '${this.escapeString(text)}')`);
    }

    if (spans.length === 0) return null;
    if (spans.length === 1 && !spans[0].includes('style:') && !spans[0].includes('recognizer:')) {
      const m = spans[0].match(/TextSpan\(text: '(.*)'\)$/s);
      if (m) return `Text('${m[1]}')`;
    }
    return `RichText(text: TextSpan(children: [${spans.join(', ')}]))`;
  },

  collectTextSpans(node, _context) {
    const spans = [];
    for (const child of this._visibleChildren(node)) {
      if (child.type === 'text') {
        const t = child.content;
        if (t) spans.push(`TextSpan(text: '${this.escapeString(t)}')`);
      } else {
        const text = this.extractAllText(child);
        if (!text) continue;
        const sp = this.buildTextSpanStyle(child.styles || {}, child.tagName);
        if (sp) {
          spans.push(`TextSpan(text: '${this.escapeString(text)}', style: TextStyle(${sp}))`);
        } else {
          spans.push(`TextSpan(text: '${this.escapeString(text)}')`);
        }
      }
    }
    return spans;
  },

  buildTextSpanStyle(styles, tagName = 'span') {
    const props = [];

    if (tagName === 'b' || tagName === 'strong') props.push('fontWeight: FontWeight.bold');
    if (tagName === 'i' || tagName === 'em')     props.push('fontStyle: FontStyle.italic');
    if (tagName === 'u')                          props.push('decoration: TextDecoration.underline');
    if (tagName === 's' || tagName === 'strike' || tagName === 'del')
                                                  props.push('decoration: TextDecoration.lineThrough');
    if (tagName === 'mark')                       props.push('backgroundColor: Color(0xFFFFFF00)');
    if (tagName === 'code' || tagName === 'pre')  props.push("fontFamily: 'monospace'");
    if (tagName === 'sub')                        props.push('fontSize: 10, fontFeatures: [FontFeature.subscripts()]');
    if (tagName === 'sup')                        props.push('fontSize: 10, fontFeatures: [FontFeature.superscripts()]');

    if (styles.fontWeight) {
      const fw = StyleParser.fontWeightToFlutter(styles.fontWeight);
      if (fw) props.push(`fontWeight: ${fw}`);
    }
    if (styles.fontStyle === 'italic') props.push('fontStyle: FontStyle.italic');
    if (styles.color) {
      const c = StyleParser.colorToFlutter(styles.color);
      if (c) props.push(`color: ${c}`);
    }
    if (styles.fontSize) {
      const dim = StyleParser.parseDimension(styles.fontSize);
      if (dim) props.push(`fontSize: ${dim.value}`);
    }
    if (styles.fontFamily) {
      const ff = styles.fontFamily.split(',')[0].trim().replace(/['"]/g, '');
      if (ff) props.push(`fontFamily: '${ff}'`);
    }
    if (styles.textDecoration) {
      const td  = StyleParser.textDecorationToFlutter(styles.textDecoration);
      const tds = StyleParser.textDecorationStyleToFlutter(styles.textDecoration);
      if (td)  props.push(`decoration: ${td}`);
      if (tds) props.push(`decorationStyle: ${tds}`);
    }
    if (styles.backgroundColor) {
      const bg = StyleParser.colorToFlutter(styles.backgroundColor);
      if (bg) props.push(`backgroundColor: ${bg}`);
    }

    return props.length > 0 ? props.join(', ') : null;
  },

  generateElement(node, context) {
    const tag = node.tagName;
    switch (tag) {
      case 'div':
      case 'section':
      case 'article':
      case 'main':
      case 'aside':
      case 'header':
      case 'footer':
      case 'nav':          return this.generateDiv(node, context);
      case 'p':            return this.generateParagraph(node, context);
      case 'span':         return this.generateSpan(node, context);
      case 'br':           return 'const SizedBox(height: 8)';
      case 'hr':           return 'const Divider()';
      case 'h1': case 'h2': case 'h3':
      case 'h4': case 'h5': case 'h6': return this.generateHeading(node, context);
      case 'b':
      case 'strong':       return this.generateBold(node, context);
      case 'i':
      case 'em':           return this.generateItalic(node, context);
      case 'u':            return this.generateUnderline(node, context);
      case 's':
      case 'strike':
      case 'del':          return this.generateStrikethrough(node, context);
      case 'mark':         return this.generateMark(node, context);
      case 'a':            return this.generateLink(node, context);
      case 'img':          return this.generateImage(node, context);
      case 'ul':
      case 'ol':           return this.generateList(node, context);
      case 'li':           return this.generateListItem(node, context);
      case 'label':        return this.generateLabel(node, context);
      case 'code':
      case 'pre':          return this.generateCode(node, context);
      case 'blockquote':   return this.generateBlockquote(node, context);
      case 'table':        return this.generateTable(node, context);
      case 'svg':          return '';
      case 'script': case 'style': case 'head':
      case 'meta': case 'link': case 'title':
        return '';
      default:             return this.generateChildren(node, context);
    }
  },

  generateDiv(node, context) {
    const ind    = context.indent;
    const styles = node.styles || {};

    const decorationProps = [];
    const containerProps  = [];

    if (styles.backgroundColor) {
      const c = StyleParser.colorToFlutter(styles.backgroundColor);
      decorationProps.push(`color: ${c}`);
    }

    const border = StyleParser.cellBorderToFlutter(styles);
    if (border) decorationProps.push(`border: ${border}`);

    if (!border && styles.borderWidth && styles.borderColor) {
      const w = StyleParser.parseDimension(styles.borderWidth)?.value || 1;
      const c = StyleParser.colorToFlutter(styles.borderColor);
      decorationProps.push(`border: Border.all(color: ${c}, width: ${w})`);
    }

    if (styles.borderRadius) {
      const r = StyleParser.parseDimension(styles.borderRadius)?.value || 4;
      decorationProps.push(`borderRadius: BorderRadius.circular(${r})`);
    }

    const padding = this.generateEdgeInsets(styles, 'padding');
    if (padding) containerProps.push(`padding: ${padding}`);

    const margin = this.generateEdgeInsets(styles, 'margin');
    if (margin) containerProps.push(`margin: ${margin}`);

    let fixedWidth = null;
    if (styles.width) {
      const dim = StyleParser.parseDimension(styles.width);
      if (dim && dim.unit !== '%') { containerProps.push(`width: ${dim.value}`); fixedWidth = dim.value; }
      else if (!dim || dim.unit === '%') containerProps.push('width: double.infinity');
    } else {
      containerProps.push('width: double.infinity');
    }
    if (styles.height) {
      const dim = StyleParser.parseDimension(styles.height);
      if (dim && dim.unit !== '%') containerProps.push(`height: ${dim.value}`);
    }

    if (decorationProps.length > 0) {
      containerProps.push(`decoration: BoxDecoration(${decorationProps.join(', ')})`);
    }

    const prevContainerWidth = context.containerWidth;
    if (fixedWidth != null) context.containerWidth = fixedWidth;

    const childCode = this.hasMixedInlineContent(node)
      ? (this.generateInlineContent(node, context) || this.generateChildren(node, context))
      : this.generateChildren(node, context);

    context.containerWidth = prevContainerWidth;

    let code = `Container(
${containerProps.map(p => `${ind}${p},`).join('\n')}
${ind}child: ${childCode},
)`;

    if (fixedWidth != null) {
      code = `UnconstrainedBox(\n${ind}alignment: Alignment.topLeft,\n${ind}child: ${code},\n)`;
    }

    if (styles.rotateAngle != null && styles.rotateAngle !== 0) {
      const radians = (styles.rotateAngle * Math.PI / 180).toFixed(4);
      code = `Transform.rotate(angle: ${radians}, child: ${code})`;
    }

    return code;
  },

  generateParagraph(node, context) {
    const ind    = context.indent;
    const styles = node.styles || {};

    const text      = this.escapeString(this.extractAllText(node));
    const alignCode = StyleParser.textAlignToFlutter(styles.textAlign);
    const sp        = this.buildTextSpanStyle(styles, 'span');

    const textArgs = [`'${text}'`];
    if (alignCode) textArgs.push(`textAlign: ${alignCode}`);
    if (sp) textArgs.push(`style: TextStyle(${sp})`);

    let inner = `Text(${textArgs.join(', ')})`;

    const margin = this.generateEdgeInsets(styles, 'margin');
    if (margin) return `Container(\n${ind}margin: ${margin},\n${ind}child: ${inner},\n)`;
    return inner;
  },

  generateSpan(node, context) {
    const styles = node.styles || {};

    if (this.hasMixedInlineContent(node)) {
      return this.generateInlineContent(node, context) || this.generateChildren(node, context);
    }

    const text = this.extractAllText(node);
    if (!text) return '';

    const sp = this.buildTextSpanStyle(styles, 'span');

    let widget;
    if (sp) {
      widget = `Text('${this.escapeString(text)}', style: TextStyle(${sp}))`;
    } else {
      widget = `Text('${this.escapeString(text)}')`;
    }

    if (styles.rotateAngle != null && styles.rotateAngle !== 0) {
      const radians = (styles.rotateAngle * Math.PI / 180).toFixed(4);
      widget = `Transform.rotate(angle: ${radians}, child: ${widget})`;
    }

    return widget;
  },

  generateHeading(node, context) {
    const ind    = context.indent;
    const tag    = node.tagName;
    const styles = node.styles || {};
    const defaults = { h1:28, h2:22, h3:18, h4:16, h5:14, h6:12 };
    const size = (styles.fontSize && StyleParser.parseDimension(styles.fontSize)?.value) || defaults[tag] || 16;

    // Merge heading defaults (size + bold) with any inline styles
    const headingStyles = { ...styles, fontSize: `${size}px`, fontWeight: styles.fontWeight || 'bold' };
    const sp = this.buildTextSpanStyle(headingStyles, 'span');

    const alignCode = StyleParser.textAlignToFlutter(styles.textAlign);
    const text      = this.escapeString(this.extractAllText(node));
    const textArgs  = [`'${text}'`];
    if (alignCode) textArgs.push(`textAlign: ${alignCode}`);
    textArgs.push(`style: TextStyle(${sp})`);

    let inner = `Text(${textArgs.join(', ')})`;

    const margin = this.generateEdgeInsets(styles, 'margin');
    if (margin) return `Container(\n${ind}margin: ${margin},\n${ind}child: ${inner},\n)`;
    return inner;
  },

  _generateStyledText(node, styleProp) {
    const text = this.extractAllText(node);
    return `Text('${this.escapeString(text)}', style: const TextStyle(${styleProp}))`;
  },

  generateBold(node, _context)          { return this._generateStyledText(node, 'fontWeight: FontWeight.bold'); },
  generateItalic(node, _context)        { return this._generateStyledText(node, 'fontStyle: FontStyle.italic'); },
  generateUnderline(node, _context)     { return this._generateStyledText(node, 'decoration: TextDecoration.underline'); },
  generateStrikethrough(node, _context) { return this._generateStyledText(node, 'decoration: TextDecoration.lineThrough'); },

  generateMark(node, _context) {
    const text = this.extractAllText(node);
    return `Container(color: const Color(0xFFFFFF00), child: Text('${this.escapeString(text)}'))`;
  },

  generateLink(node, context) {
    const text = this.extractAllText(node);
    const href = node.attributes?.href || '#';
    context.usesGesture = true;
    return `InkWell(
  onTap: () { /* ${this.escapeString(href)} */ },
  child: Text('${this.escapeString(text)}', style: const TextStyle(color: Color(0xFF1976D2), decoration: TextDecoration.underline)),
)`;
  },

  generateImage(node, _context) {
    const src    = node.attributes?.src || '';
    const alt    = node.attributes?.alt || '';
    const width  = node.attributes?.width  || node.styles?.width;
    const height = node.attributes?.height || node.styles?.height;

    const props = [];
    if (width)  { const d = StyleParser.parseDimension(width);  if (d) props.push(`width: ${d.value}`); }
    if (height) { const d = StyleParser.parseDimension(height); if (d) props.push(`height: ${d.value}`); }
    props.push('fit: BoxFit.contain');

    if (src.startsWith('http')) return `Image.network('${src}', ${props.join(', ')})`;
    if (src.startsWith('assets/')) return `Image.asset('${src}', ${props.join(', ')})`;
    if (src.startsWith('data:')) return `Image.memory(base64Decode('...') /* ${alt} */, ${props.join(', ')})`;
    return `const Placeholder() /* ${alt || src} */`;
  },

  generateList(node, context) {
    const ind       = context.indent;
    const isOrdered = node.tagName === 'ol';
    const items = node.children
      .filter(c => c.tagName === 'li' || (c.type === 'element' && c.tagName === 'li'))
      .map((c, i) => {
        const text   = this.extractAllText(c);
        const prefix = isOrdered ? `${i + 1}. ` : '• ';
        return `Text('${prefix}${this.escapeString(text)}')`;
      });
    return `Column(
${ind}crossAxisAlignment: CrossAxisAlignment.start,
${ind}children: [
${items.map(item => `${ind}  ${item},`).join('\n')}
${ind}],
)`;
  },

  generateListItem(node, _context) {
    const text = this.extractAllText(node);
    return `Text('• ${this.escapeString(text)}')`;
  },

  generateLabel(node, _context) {
    const text = this.extractAllText(node);
    return `Text('${this.escapeString(text)}')`;
  },

  generateCode(node, context) {
    const text = this.extractAllText(node);
    const ind  = context.indent;
    return `Container(
${ind}padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
${ind}color: const Color(0xFFF5F5F5),
${ind}child: Text('${this.escapeString(text)}', style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
)`;
  },

  generateBlockquote(node, context) {
    const ind   = context.indent;
    const child = this.generateChildren(node, context);
    return `Container(
${ind}margin: const EdgeInsets.symmetric(vertical: 4),
${ind}padding: const EdgeInsets.only(left: 12),
${ind}decoration: const BoxDecoration(border: Border(left: BorderSide(color: Color(0xFFBDBDBD), width: 4))),
${ind}child: ${child},
)`;
  },

  generateTable(node, context) {
    context.usesTable = true;
    return TableHandler.generate(node, context, context.bodyStyles || null);
  },

  generateInput(node, context) {
    const ind         = context.indent;
    const name        = node.name || `input_${context.controllers.size}`;
    const type        = node.inputType || 'text';
    const placeholder = node.placeholder;
    const required    = node.required;
    const readonly    = node.readonly;

    context.controllers.set(name, { type: 'text', name });

    const ctrl = this.toControllerName(name);

    const kbMap = { number:'TextInputType.number', email:'TextInputType.emailAddress', tel:'TextInputType.phone', url:'TextInputType.url' };
    const keyboardType = kbMap[type] || 'TextInputType.text';

    const decorationProps = [
      'border: const OutlineInputBorder()',
      'isDense: true',
      'contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10)',
    ];
    if (placeholder) decorationProps.push(`hintText: '${this.escapeString(placeholder)}'`);
    if (required)    decorationProps.push('filled: true', 'fillColor: Colors.yellow.shade100');

    const tf = `TextField(
${ind}  controller: ${ctrl},
${ind}  keyboardType: ${keyboardType},
${ind}  readOnly: ${readonly},
${ind}  decoration: InputDecoration(
${ind}    ${decorationProps.join(`,\n${ind}    `)},
${ind}  ),
${ind})`;

    if (node.styles?.width) {
      const dim = StyleParser.parseDimension(node.styles.width);
      if (dim && dim.unit !== '%') {
        return `SizedBox(\n${ind}width: ${dim.value},\n${ind}child: ${tf},\n)`;
      }
    }
    return tf;
  },

  generateSelect(node, context) {
    const ind  = context.indent;
    const name = node.name || `select_${context.dropdowns.size}`;

    const options = node.children
      .filter(c => c.type === 'option')
      .map(opt => ({ value: opt.value, label: opt.label || opt.value }));
    context.dropdowns.set(name, { name, options });

    const varName     = this.toVariableName(name);
    const optionItems = options.map(opt =>
      `DropdownMenuItem(value: '${opt.value}', child: Text('${this.escapeString(opt.label)}'))`
    );

    return `DropdownButton<String>(
${ind}value: ${varName},
${ind}hint: const Text('เลือก...'),
${ind}items: const [
${optionItems.map(i => `${ind}  ${i},`).join('\n')}
${ind}],
${ind}onChanged: (value) {
${ind}  setState(() { ${varName} = value; });
${ind}},
)`;
  },

  generateTextArea(node, context) {
    const ind         = context.indent;
    const name        = node.name || `textarea_${context.controllers.size}`;
    const placeholder = node.placeholder;
    const rows        = node.rows || 3;

    context.controllers.set(name, { type: 'textarea', name });

    const ctrl = this.toControllerName(name);

    let width = 'double.infinity';
    if (node.styles?.width) {
      const dim = StyleParser.parseDimension(node.styles.width);
      if (dim && dim.unit !== '%') width = dim.value;
    }

    return `SizedBox(
${ind}width: ${width},
${ind}child: TextField(
${ind}  controller: ${ctrl},
${ind}  maxLines: ${rows},
${ind}  decoration: InputDecoration(
${ind}    border: const OutlineInputBorder(),
${ind}    isDense: true,
${ind}    contentPadding: const EdgeInsets.all(10),
${placeholder ? `${ind}    hintText: '${this.escapeString(placeholder)}',` : ''}
${ind}  ),
${ind}),
)`;
  },

  generateDatePicker(node, context) {
    const ind         = context.indent;
    const name        = node.name || `date_${context.controllers.size}`;
    const placeholder = node.placeholder || 'เลือกวันที่...';

    context.controllers.set(name, { type: 'date', name });

    const ctrl = this.toControllerName(name);

    return `SizedBox(
${ind}width: 200,
${ind}child: TextField(
${ind}  controller: ${ctrl},
${ind}  readOnly: true,
${ind}  decoration: InputDecoration(
${ind}    border: const OutlineInputBorder(),
${ind}    isDense: true,
${ind}    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
${ind}    hintText: '${this.escapeString(placeholder)}',
${ind}    suffixIcon: const Icon(Icons.calendar_today, size: 18),
${ind}  ),
${ind}  onTap: () async {
${ind}    final picked = await showDatePicker(
${ind}      context: context,
${ind}      initialDate: DateTime.now(),
${ind}      firstDate: DateTime(1950),
${ind}      lastDate: DateTime(2100),
${ind}    );
${ind}    if (picked != null) {
${ind}      ${ctrl}.text = '\${picked.day.toString().padLeft(2, '0')}-\${picked.month.toString().padLeft(2, '0')}-\${picked.year}';
${ind}    }
${ind}  },
${ind}),
)`;
  },

  generateSignature(node, _context) {
    _context.usesFormWidgets = true;
    const name = node.name || 'signature';
    const props = [`name: '${name}'`];
    if (node.width) props.push(`width: ${parseFloat(node.width) || 200}`);
    if (node.height) props.push(`height: ${parseFloat(node.height) || 100}`);
    if (node.value) props.push(`value: '${this.escapeString(node.value)}'`);
    return `FormSignature(${props.join(', ')})`;
  },

  generateImageUpload(node, _context) {
    _context.usesFormWidgets = true;
    const name = node.name || 'image';
    const props = [`name: '${name}'`];
    if (node.source && node.source !== 'both') props.push(`source: '${node.source}'`);
    if (node.width) props.push(`width: ${parseFloat(node.width) || 150}`);
    if (node.height) props.push(`height: ${parseFloat(node.height) || 150}`);
    if (node.required) props.push('required: true');
    return `FormImageUpload(${props.join(', ')})`;
  },

  generateCheckbox(node, context) {
    context.usesFormWidgets = true;
    const name = node.name || `checkbox_${context.checkboxes.size}`;
    context.checkboxes.set(name, { name });
    const props = [`name: '${name}'`];
    if (node.label) props.push(`label: '${this.escapeString(node.label)}'`);
    if (node.options && node.options.length) props.push(`options: [${node.options.map(o => `'${this.escapeString(o)}'`).join(', ')}]`);
    if (node.hasOther) props.push('hasOther: true');
    if (node.value) props.push(`value: '${this.escapeString(String(node.value))}'`);
    if (node.disabled) props.push('disabled: true');
    return `FormCheckbox(${props.join(', ')})`;
  },

  generateRadio(node, _context) {
    _context.usesFormWidgets = true;
    const name = node.name || 'radio';
    const props = [`name: '${name}'`];
    if (node.options && node.options.length) props.push(`options: [${node.options.map(o => `'${this.escapeString(o)}'`).join(', ')}]`);
    if (node.value) props.push(`value: '${this.escapeString(node.value)}'`);
    if (node.required) props.push('required: true');
    if (node.disabled) props.push('disabled: true');
    return `FormRadio(${props.join(', ')})`;
  },

  generateFile(node, _context) {
    _context.usesFormWidgets = true;
    const name = node.name || 'file';
    const props = [`name: '${name}'`];
    if (node.accept) props.push(`accept: '${node.accept}'`);
    if (node.multiple) props.push('multiple: true');
    if (node.maxSize) props.push(`maxSizeMb: ${node.maxSize}`);
    if (node.required) props.push('required: true');
    return `FormFile(${props.join(', ')})`;
  },

  generateSearch(node, _context) {
    _context.usesFormWidgets = true;
    const name = node.name || 'search';
    const props = [`name: '${name}'`, `source: '${node.source || ''}'`];
    if (node.display) props.push(`displayFields: '${node.display}'`);
    if (node.valueField) props.push(`valueField: '${node.valueField}'`);
    if (node.fields) props.push(`fields: '${node.fields}'`);
    if (node.placeholder) props.push(`placeholder: '${this.escapeString(node.placeholder)}'`);
    if (node.required) props.push('required: true');
    return `FormSearch(${props.join(', ')})`;
  },

  generateControllers(context) {
    const lines = [];
    for (const [name] of context.controllers) {
      lines.push(`final ${this.toControllerName(name)} = TextEditingController();`);
    }
    return lines.join('\n');
  },

  generateStateVariables(context) {
    const lines = [];
    for (const [name, info] of context.dropdowns) {
      const varName    = this.toVariableName(name);
      const firstValue = info.options[0]?.value || '';
      lines.push(`String? ${varName} = '${firstValue}';`);
    }
    for (const [name] of context.checkboxes) {
      lines.push(`bool ${this.toVariableName(name)} = false;`);
    }
    return lines.join('\n');
  },

  generateImports(context) {
    const imports = new Set(["import 'package:flutter/material.dart';"]);
    if (context.usesGesture) {
      imports.add("import 'package:flutter/gestures.dart';");
    }
    if (context.usesFormWidgets || context.checkboxes.size > 0 || context.controllers.size > 0 || context.dropdowns.size > 0) {
      imports.add("import 'form_widgets/form_widgets.dart';");
    }
    return Array.from(imports).join('\n');
  },

  generateBoilerplate(context, widgetCode = '') {
    if (!context.usesTable && !context.usesDiagonalBorder && !context.usesComment) {
      return '// No helper classes needed';
    }
    const parts = [];

    // ── Text / border helpers (always added alongside table boilerplate) ─────
    if (context.usesTable) {
      parts.push(`// ── Text helpers ──────────────────────────────────────────────────────────────

Widget _t(String s, {double sz = 16, bool bold = false, Color? color, String ff = 'Browallia New', TextAlign? align}) =>
    Text(s, style: TextStyle(fontFamily: ff, fontSize: sz, fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: color), softWrap: true, overflow: TextOverflow.clip, textAlign: align);

Widget _rt(List<(String, bool)> spans, {double sz = 16, String ff = 'Browallia New', TextAlign align = TextAlign.start}) =>
    RichText(softWrap: true, overflow: TextOverflow.clip, textAlign: align,
        text: TextSpan(style: TextStyle(fontFamily: ff, fontSize: sz),
            children: [for (final (t, b) in spans) TextSpan(text: t, style: b ? const TextStyle(fontWeight: FontWeight.bold) : null)]));

// ── Border helpers ────────────────────────────────────────────────────────────

const _bk = Colors.black;` +
        (widgetCode.includes('_bTop(')       ? `\nBorder _bTop([double w = 1])    => Border(top:    BorderSide(color: _bk, width: w));` : '') +
        (widgetCode.includes('_bBottom(')    ? `\nBorder _bBottom([double w = 1]) => Border(bottom: BorderSide(color: _bk, width: w));` : '') +
        (widgetCode.includes('_bLeft(')      ? `\nBorder _bLeft([double w = 1])   => Border(left:   BorderSide(color: _bk, width: w));` : '') +
        (widgetCode.includes('_bRight(')     ? `\nBorder _bRight([double w = 1])  => Border(right:  BorderSide(color: _bk, width: w));` : '') +
        (widgetCode.includes('_bTopBottom(') ? `\nBorder _bTopBottom(double t, double b) => Border(top: BorderSide(color: _bk, width: t), bottom: BorderSide(color: _bk, width: b));` : '') +
        (widgetCode.includes('_bAll(')       ? `\nBorder _bAll([double w = 1]) => Border.all(color: _bk, width: w);` : '') +
        ``);
    }

    if (context.usesTable) {
      parts.push(`class _TableGridPainter extends CustomPainter {
  final List<double> colStarts;
  final List<double> rowStarts;
  final Color borderColor;
  final double borderWidth;
  final List<List<int>> matrixData;
  final int numRows;
  final int numCols;

  const _TableGridPainter({
    required this.colStarts,
    required this.rowStarts,
    required this.borderColor,
    required this.borderWidth,
    required this.matrixData,
    required this.numRows,
    required this.numCols,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (borderWidth == 0) return;
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < numCols; c++) {
        if (c >= colStarts.length - 1 || r >= rowStarts.length - 1) continue;
        final idx = (r < matrixData.length && c < matrixData[r].length)
            ? matrixData[r][c]
            : -1;
        if (idx < 0) continue;
        final sameAsLeft  = c > 0 && matrixData[r][c - 1] == idx;
        final sameAsAbove = r > 0 && matrixData[r - 1][c] == idx;
        if (sameAsLeft || sameAsAbove) continue;
        int endC = c + 1;
        while (endC < numCols && endC < matrixData[r].length && matrixData[r][endC] == idx) endC++;
        int endR = r + 1;
        while (endR < numRows && endR < matrixData.length && matrixData[endR][c] == idx) endR++;
        final right  = endC < colStarts.length ? colStarts[endC] : colStarts.last;
        final bottom = endR < rowStarts.length ? rowStarts[endR] : rowStarts.last;
        canvas.drawRect(Rect.fromLTRB(colStarts[c], rowStarts[r], right, bottom), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_TableGridPainter old) =>
      old.borderColor != borderColor || old.borderWidth != borderWidth;
}`);
    }

    if (context.usesDiagonalBorder) {
      parts.push(`class _DiagonalBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool topLeftToBottomRight;
  final bool bottomLeftToTopRight;

  const _DiagonalBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.topLeftToBottomRight,
    required this.bottomLeftToTopRight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    if (topLeftToBottomRight) {
      canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);
    }
    if (bottomLeftToTopRight) {
      canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
    }
  }

  @override
  bool shouldRepaint(_DiagonalBorderPainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.topLeftToBottomRight != topLeftToBottomRight ||
      old.bottomLeftToTopRight != bottomLeftToTopRight;
}`);
    }

    if (context.usesComment) {
      parts.push(`class _CommentIndicatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFFF0000);
    final path = Path()
      ..moveTo(size.width - 6, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, 6)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CommentIndicatorPainter old) => false;
}`);
    }

    return parts.join('\n\n');
  },

  generateEdgeInsets(styles, prefix) {
    const top    = styles[`${prefix}Top`];
    const right  = styles[`${prefix}Right`];
    const bottom = styles[`${prefix}Bottom`];
    const left   = styles[`${prefix}Left`];
    if (!top && !right && !bottom && !left) return null;

    const t = StyleParser.parseDimension(top)?.value    || 0;
    const r = StyleParser.parseDimension(right)?.value  || 0;
    const b = StyleParser.parseDimension(bottom)?.value || 0;
    const l = StyleParser.parseDimension(left)?.value   || 0;

    if (t === r && r === b && b === l) return `const EdgeInsets.all(${t})`;
    if (t === b && l === r)            return `const EdgeInsets.symmetric(vertical: ${t}, horizontal: ${l})`;
    return `const EdgeInsets.fromLTRB(${l}, ${t}, ${r}, ${b})`;
  },

  extractAllText(node) {
    if (node.type === 'text') return node.content;
    if (node.type === 'svg') return '';
    if (node.styles?.position === 'absolute') return '';
    let text = '';
    for (const c of (node.children || [])) text += this.extractAllText(c);
    return text.trim();
  },

  escapeString(str) {
    if (!str) return '';
    return String(str)
      .replace(/\\/g, '\\\\')
      .replace(/'/g, "\\'")
      .replace(/\n/g, '\\n')
      .replace(/\r/g, '')
      .replace(/\t/g, '\\t')
      .replace(/\$/g, '\\$');
  },

  toControllerName(name) { return `_${this.toCamelCase(name)}Controller`; },
  toVariableName(name)   { return `_${this.toCamelCase(name)}`; },

  toCamelCase(str) {
    return str
      .replace(/[-_\s]+(.)?/g, (_, c) => c ? c.toUpperCase() : '')
      .replace(/^./, c => c.toLowerCase());
  },
};

if (typeof window !== 'undefined') window.DartGenerator = DartGenerator;
if (typeof module !== 'undefined') module.exports = DartGenerator;
