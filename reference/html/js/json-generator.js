const JsonGenerator = {

  generate(ast, _options = {}) {
    const context = {
      fields: [],
      fieldIndex: 0,
    };

    if (ast.bodyStyles) context.bodyStyles = ast.bodyStyles;

    const pageAsts = this._splitPages(ast);
    const pages = pageAsts.map(pageAst => this._generateNode(pageAst, context));

    return {
      version: '1.0',
      pages,
      fields: context.fields,
    };
  },

  _splitPages(ast) {
    const segments = [];
    let current = [];
    const walk = (children) => {
      for (const child of children) {
        if (child.type === 'element' && child.tagName === 'pagebreak') {
          segments.push(current);
          current = [];
          walk(child.children || []);
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

  _generateNode(node, ctx) {
    if (!node) return null;
    switch (node.type) {
      case 'document':    return this._genDocument(node, ctx);
      case 'text':        return this._genText(node);
      case 'table':       return this._genTable(node, ctx);
      case 'input':       return this._genInput(node, ctx);
      case 'select':      return this._genSelect(node, ctx);
      case 'textarea':    return this._genTextArea(node, ctx);
      case 'date-picker': return this._genDatePicker(node, ctx);
      case 'signature':   return this._genSignature(node, ctx);
      case 'image-upload':return this._genImageUpload(node, ctx);
      case 'checkbox':    return this._genCheckbox(node, ctx);
      case 'radio':       return this._genRadio(node, ctx);
      case 'file':        return this._genFile(node, ctx);
      case 'search':      return this._genSearch(node, ctx);
      case 'svg':         return null;
      case 'option':      return null;
      case 'tr': case 'td': case 'th':
      case 'thead': case 'tbody': case 'tfoot':
      case 'colgroup': case 'col': case 'caption':
        return null;
      case 'element':     return this._genElement(node, ctx);
      default:            return this._genChildren(node, ctx);
    }
  },

  _genDocument(node, ctx) {
    const children = (node.children || [])
      .map(c => this._generateNode(c, ctx))
      .filter(Boolean);
    if (children.length === 0) return null;
    if (children.length === 1) return children[0];
    return { type: 'column', children };
  },

  _genChildren(node, ctx) {
    const visible = (node.children || []).filter(c =>
      c.type !== 'svg' && c.styles?.position !== 'absolute'
    );
    const children = visible
      .map(c => this._generateNode(c, ctx))
      .filter(Boolean);
    if (children.length === 0) return null;
    if (children.length === 1) return children[0];
    return { type: 'column', children };
  },

  _genText(node) {
    const text = this._collapseWS(node.content).trim();
    if (!text) return null;
    return { type: 'text', content: text };
  },

  _hasMixedInlineContent(node) {
    if (!node.children) return false;
    const visible = node.children.filter(c => c.type !== 'svg' && c.styles?.position !== 'absolute');
    const hasText = visible.some(c => c.type === 'text' && c.content.trim());
    const hasSpan = visible.some(c =>
      ['span', 'a', 'b', 'strong', 'i', 'em', 'u', 's', 'strike', 'del', 'mark', 'code', 'sub', 'sup'].includes(c.tagName)
    );
    return hasText || hasSpan;
  },

  _genInlineContent(node, ctx) {
    const visible = (node.children || []).filter(c =>
      c.type !== 'svg' && c.styles?.position !== 'absolute'
    );

    const spans = [];
    for (const child of visible) {
      if (child.type === 'text') {
        const t = this._collapseWS(child.content).trim();
        if (t) spans.push({ text: t });
        continue;
      }
      if (child.tagName === 'br') {
        spans.push({ text: '\n' });
        continue;
      }
      if (child.tagName === 'a') {
        const text = this._extractAllText(child);
        if (!text) continue;
        spans.push({ text, style: { color: '#1976D2', decoration: 'underline' }, href: child.attributes?.href || '#' });
        continue;
      }
      const inlineTags = ['span', 'b', 'strong', 'i', 'em', 'u', 's', 'strike', 'del', 'mark', 'code', 'sub', 'sup'];
      if (inlineTags.includes(child.tagName)) {
        if (this._hasMixedInlineContent(child)) {
          const nested = this._collectTextSpans(child);
          spans.push(...nested);
        } else {
          const text = this._extractAllText(child);
          if (!text) continue;
          const style = this._buildSpanStyle(child.styles || {}, child.tagName);
          if (style) {
            spans.push({ text, style });
          } else {
            spans.push({ text });
          }
        }
        continue;
      }
      const text = this._extractAllText(child);
      if (text.trim()) spans.push({ text });
    }

    if (spans.length === 0) return null;
    if (spans.length === 1 && !spans[0].style && !spans[0].href) {
      return { type: 'text', content: spans[0].text };
    }
    return { type: 'richtext', spans };
  },

  _collectTextSpans(node) {
    const parentStyle = this._buildSpanStyle(node.styles || {}, node.tagName);
    const spans = [];
    for (const child of (node.children || [])) {
      if (child.type === 'svg' || child.styles?.position === 'absolute') continue;
      if (child.type === 'text') {
        const t = this._collapseWS(child.content).trim();
        if (t) spans.push(parentStyle ? { text: t, style: { ...parentStyle } } : { text: t });
      } else {
        const text = this._extractAllText(child);
        if (!text) continue;
        const childStyle = this._buildSpanStyle(child.styles || {}, child.tagName);
        const merged = { ...(parentStyle || {}), ...(childStyle || {}) };
        spans.push(Object.keys(merged).length ? { text, style: merged } : { text });
      }
    }
    return spans;
  },

  _buildSpanStyle(styles, tagName = 'span') {
    const s = {};
    if (tagName === 'b' || tagName === 'strong') s.fontWeight = 'bold';
    if (tagName === 'i' || tagName === 'em')     s.fontStyle = 'italic';
    if (tagName === 'u')                          s.decoration = 'underline';
    if (tagName === 's' || tagName === 'strike' || tagName === 'del') s.decoration = 'lineThrough';
    if (tagName === 'mark')                       s.backgroundColor = '#FFFF00';
    if (tagName === 'code' || tagName === 'pre')  s.fontFamily = 'monospace';
    if (tagName === 'sub')                        { s.fontSize = 10; s.baseline = 'sub'; }
    if (tagName === 'sup')                        { s.fontSize = 10; s.baseline = 'sup'; }

    if (styles.fontWeight) s.fontWeight = styles.fontWeight;
    if (styles.fontStyle === 'italic') s.fontStyle = 'italic';
    if (styles.color) s.color = styles.color;
    if (styles.fontSize) s.fontSize = this._parseDim(styles.fontSize);
    if (styles.fontFamily) s.fontFamily = styles.fontFamily.split(',')[0].trim().replace(/['"]/g, '');
    if (styles.textDecoration) s.decoration = this._mapTextDecoration(styles.textDecoration);
    if (styles.backgroundColor) s.backgroundColor = styles.backgroundColor;

    return Object.keys(s).length > 0 ? s : null;
  },

  _mapTextDecoration(val) {
    if (!val) return null;
    if (val.includes('underline')) return 'underline';
    if (val.includes('line-through')) return 'lineThrough';
    if (val.includes('overline')) return 'overline';
    return null;
  },

  _genElement(node, ctx) {
    const tag = node.tagName;
    switch (tag) {
      case 'div': case 'section': case 'article': case 'main':
      case 'aside': case 'header': case 'footer': case 'nav':
        return this._genContainer(node, ctx);
      case 'p':
        return this._genParagraph(node, ctx);
      case 'br':
        return { type: 'spacer', height: 8 };
      case 'hr':
        return { type: 'divider' };
      case 'h1': case 'h2': case 'h3':
      case 'h4': case 'h5': case 'h6':
        return this._genHeading(node, ctx);
      case 'b': case 'strong':
        return this._genStyledText(node, { fontWeight: 'bold' });
      case 'i': case 'em':
        return this._genStyledText(node, { fontStyle: 'italic' });
      case 'u':
        return this._genStyledText(node, { decoration: 'underline' });
      case 's': case 'strike': case 'del':
        return this._genStyledText(node, { decoration: 'lineThrough' });
      case 'mark':
        return this._genStyledText(node, { backgroundColor: '#FFFF00' });
      case 'a':
        return { type: 'text', content: this._extractAllText(node), href: node.attributes?.href || '#', style: { color: '#1976D2', decoration: 'underline' } };
      case 'img':
        return this._genImage(node);
      case 'ul': case 'ol':
        return this._genList(node, ctx);
      case 'li':
        return this._genListItem(node, ctx);
      case 'span':
        return this._genSpan(node, ctx);
      case 'label':
        return this._genStyledText(node, null);
      case 'code': case 'pre':
        return this._genCode(node);
      case 'blockquote':
        return this._genBlockquote(node, ctx);
      case 'table':
        return this._genTable(node, ctx);
      case 'script': case 'style': case 'head':
      case 'meta': case 'link': case 'title': case 'svg':
        return null;
      default:
        return this._genChildren(node, ctx);
    }
  },

  _genStyledText(node, defaultStyle) {
    if (this._hasTrulyMixedChildren(node)) {
      const rt = this._genInlineContent(node);
      if (rt) {
        if (defaultStyle) {
          if (rt.type === 'richtext') {
            for (const span of rt.spans) {
              span.style = { ...defaultStyle, ...(span.style || {}) };
            }
          } else if (rt.type === 'text') {
            rt.style = { ...defaultStyle, ...(rt.style || {}) };
          }
        }
        return rt;
      }
    }
    const text = this._extractAllText(node);
    if (!text) return null;
    return { type: 'text', content: text, style: defaultStyle || undefined };
  },

  // Returns true only when node has BOTH bare text AND inline elements as children
  _hasTrulyMixedChildren(node) {
    if (!node.children) return false;
    const visible = node.children.filter(c => c.type !== 'svg' && c.styles?.position !== 'absolute');
    const hasText = visible.some(c => c.type === 'text' && (c.content || '').trim());
    const hasInline = visible.some(c =>
      ['span', 'a', 'b', 'strong', 'i', 'em', 'u', 's', 'strike', 'del', 'mark', 'code', 'sub', 'sup'].includes(c.tagName)
    );
    return hasText && hasInline;
  },

  _genContainer(node, ctx) {
    const styles = node.styles || {};

    const prevContainerWidth = ctx.containerWidth;
    if (styles.width) {
      const dim = this._parseDim(styles.width);
      if (dim) ctx.containerWidth = dim;
    }

    let child;
    if (this._hasMixedInlineContent(node)) {
      child = this._genInlineContent(node, ctx) || this._genChildren(node, ctx);
    } else {
      child = this._genChildren(node, ctx);
    }

    ctx.containerWidth = prevContainerWidth;
    if (!child) return null;

    const s = this._extractContainerStyle(styles);

    if (styles.rotateAngle != null && styles.rotateAngle !== 0) {
      s.rotateAngle = styles.rotateAngle;
    }

    if (Object.keys(s).length === 0) return child;
    return { type: 'container', style: s, child };
  },

  _genParagraph(node, ctx) {
    const styles = node.styles || {};

    const pStyle = {};
    if (styles.fontSize)   pStyle.fontSize   = this._parseDim(styles.fontSize);
    if (styles.fontFamily)  pStyle.fontFamily = styles.fontFamily.split(',')[0].trim().replace(/['"]/g, '');
    if (styles.color)       pStyle.color      = styles.color;
    if (styles.fontWeight)  pStyle.fontWeight = styles.fontWeight;
    if (styles.textAlign)   pStyle.textAlign  = styles.textAlign;
    const hasPStyle = Object.keys(pStyle).length > 0;

    let content;

    if (this._hasMixedInlineContent(node)) {
      content = this._genInlineContent(node, ctx);
      if (content && hasPStyle) {
        if (content.type === 'text') {
          content.style = { ...pStyle, ...(content.style || {}) };
        } else if (content.type === 'richtext') {
          for (const span of content.spans) {
            span.style = { ...pStyle, ...(span.style || {}) };
          }
        }
      }
    }
    if (!content) {
      const text = this._extractAllText(node);
      if (!text) return null;
      content = { type: 'text', content: text, style: hasPStyle ? pStyle : undefined };
    }

    const margin = this._extractEdgeInsets(styles, 'margin');
    if (margin) {
      return { type: 'container', style: { margin }, child: content };
    }
    return content;
  },

  _genHeading(node, ctx) {
    const tag = node.tagName;
    const defaults = { h1: 28, h2: 22, h3: 18, h4: 16, h5: 14, h6: 12 };
    const styles = node.styles || {};
    let fontSize = defaults[tag] || 16;
    if (styles.fontSize) fontSize = this._parseDim(styles.fontSize) || fontSize;

    const headingStyle = { fontSize, fontWeight: 'bold', color: styles.color || undefined };

    if (this._hasMixedInlineContent(node)) {
      const rt = this._genInlineContent(node, ctx);
      if (rt && rt.type === 'richtext') {
        for (const span of rt.spans) {
          span.style = { ...headingStyle, ...(span.style || {}) };
        }
        const margin = this._extractEdgeInsets(styles, 'margin');
        if (margin) return { type: 'container', style: { margin }, child: rt };
        return rt;
      }
    }

    const text = this._extractAllText(node);
    if (!text) return null;
    const result = { type: 'text', content: text, style: headingStyle };
    const margin = this._extractEdgeInsets(styles, 'margin');
    if (margin) return { type: 'container', style: { margin }, child: result };
    return result;
  },

  _genSpan(node, ctx) {
    const styles = node.styles || {};
    const spanStyle = this._buildSpanStyle(styles, 'span');

    if (this._hasTrulyMixedChildren(node)) {
      const rt = this._genInlineContent(node, ctx);
      if (rt) {
        if (spanStyle) {
          if (rt.type === 'richtext') {
            for (const span of rt.spans) {
              span.style = { ...spanStyle, ...(span.style || {}) };
            }
          } else if (rt.type === 'text') {
            rt.style = { ...spanStyle, ...(rt.style || {}) };
          }
        }
        return rt;
      }
    }

    const text = this._extractAllText(node);
    if (!text) return null;
    return { type: 'text', content: text, style: spanStyle || undefined };
  },

  _genCode(node) {
    const text = this._extractAllText(node);
    if (!text) return null;
    return {
      type: 'container',
      style: { backgroundColor: '#F5F5F5', padding: { top: 2, right: 6, bottom: 2, left: 6 } },
      child: { type: 'text', content: text, style: { fontFamily: 'monospace', fontSize: 13 } },
    };
  },

  _genBlockquote(node, ctx) {
    const child = this._genChildren(node, ctx);
    if (!child) return null;
    return {
      type: 'container',
      style: {
        margin: { top: 4, right: 0, bottom: 4, left: 0 },
        padding: { top: 0, right: 0, bottom: 0, left: 12 },
        borderLeft: { color: '#BDBDBD', width: 4 },
      },
      child,
    };
  },

  _genImage(node) {
    const src    = node.attributes?.src || '';
    const alt    = node.attributes?.alt || '';
    const width  = node.attributes?.width  || node.styles?.width;
    const height = node.attributes?.height || node.styles?.height;
    const r = { type: 'image', src };
    if (alt)    r.alt    = alt;
    if (width)  r.width  = this._parseDim(width);
    if (height) r.height = this._parseDim(height);
    return r;
  },

  _genList(node, ctx) {
    const ordered = node.tagName === 'ol';
    const items = (node.children || [])
      .filter(c => c.tagName === 'li' || (c.type === 'element' && c.tagName === 'li'))
      .map((c, i) => {
        if (this._hasMixedInlineContent(c)) {
          const rt = this._genInlineContent(c, ctx);
          if (rt) return rt;
        }
        return this._extractAllText(c);
      });
    return { type: 'list', ordered, items };
  },

  _genListItem(node, ctx) {
    if (this._hasMixedInlineContent(node)) {
      const rt = this._genInlineContent(node, ctx);
      if (rt) return rt;
    }
    const text = this._extractAllText(node);
    if (!text) return null;
    return { type: 'text', content: '\u2022 ' + text };
  },

  _genTable(node, ctx) {
    const tableStyles = node.styles || {};
    const tableInherited = {};
    const tfs = tableStyles.fontSize || ctx._inheritedFontSize;
    if (tfs) tableInherited.fontSize = tfs;
    const tff = tableStyles.fontFamily || ctx._inheritedFontFamily;
    if (tff) tableInherited.fontFamily = tff;
    const tfc = tableStyles.color || ctx._inheritedColor;
    if (tfc) tableInherited.color = tfc;

    const contentBuilder = (cellNode) => {
      const contentChildren = (cellNode.children || [])
        .filter(c => c.type !== 'svg' && c.styles?.position !== 'absolute');

      if (this._hasCellInlineContent(contentChildren)) {
        const rt = this._genInlineContent(cellNode, ctx);
        if (rt) return rt;
      }

      const prevWidth = ctx.containerWidth;
      const prevFs = ctx._inheritedFontSize;
      const prevFf = ctx._inheritedFontFamily;
      const prevFc = ctx._inheritedColor;
      // Calculate cell's pixel width for nested content
      if (prevWidth != null) {
        const cellWidthStr = cellNode.width || cellNode.styles?.width;
        if (cellWidthStr) {
          const d = StyleParser.parseDimension(cellWidthStr);
          if (d && d.unit === '%') ctx.containerWidth = prevWidth * (d.value / 100);
          else if (d) ctx.containerWidth = d.value;
          else ctx.containerWidth = prevWidth;
        } else {
          ctx.containerWidth = prevWidth;
        }
      } else {
        ctx.containerWidth = null;
      }
      if (tableStyles.fontSize) ctx._inheritedFontSize = tableStyles.fontSize;
      if (tableStyles.fontFamily) ctx._inheritedFontFamily = tableStyles.fontFamily;
      if (tableStyles.color) ctx._inheritedColor = tableStyles.color;

      const children = contentChildren
        .map(c => this._generateNode(c, ctx))
        .filter(Boolean);

      ctx.containerWidth = prevWidth;
      ctx._inheritedFontSize = prevFs;
      ctx._inheritedFontFamily = prevFf;
      ctx._inheritedColor = prevFc;

      if (children.length === 0) return null;
      if (children.length === 1) return children[0];

      const merged = this._mergeConsecutiveTexts(children);
      if (merged.length === 1) return merged[0];
      return { type: 'column', stretch: true, children: merged };
    };

    const inheritedStyles = Object.keys(tableInherited).length > 0 ? tableInherited : (ctx.bodyStyles || null);
    const estWidth = ctx.containerWidth || null;
    return TableHandler.generateJson(node, contentBuilder, inheritedStyles, estWidth);
  },

  _hasCellInlineContent(children) {
    const hasText = children.some(c => c.type === 'text' && (c.content || '').trim());
    const hasSpan = children.some(c =>
      ['span', 'a', 'b', 'strong', 'i', 'em', 'u', 's', 'strike', 'del', 'mark', 'code', 'sub', 'sup'].includes(c.tagName)
    );
    return hasText || hasSpan;
  },

  _genInput(node, ctx) {
    const name = node.name || `input_${ctx.fieldIndex++}`;
    const field = {
      type: 'input',
      name,
      inputType: node.inputType || 'text',
    };
    if (node.placeholder) field.placeholder = node.placeholder;
    if (node.required)    field.required = true;
    if (node.readonly)    field.readonly = true;
    if (node.disabled)    field.disabled = true;
    if (node.value)       field.value = node.value;
    if (node.pattern)     field.pattern = node.pattern;
    if (node.styles?.width) field.width = this._parseDim(node.styles.width);

    ctx.fields.push({ name, fieldType: 'input', inputType: field.inputType, placeholder: field.placeholder, required: field.required });
    return field;
  },

  _genSelect(node, ctx) {
    const name = node.name || `select_${ctx.fieldIndex++}`;
    const options = (node.children || [])
      .filter(c => c.type === 'option')
      .map(opt => ({ value: opt.value, label: opt.label || opt.value }));
    const field = { type: 'select', name, options };
    if (node.required) field.required = true;
    if (node.disabled) field.disabled = true;

    ctx.fields.push({ name, fieldType: 'select', options, required: field.required });
    return field;
  },

  _genTextArea(node, ctx) {
    const name = node.name || `textarea_${ctx.fieldIndex++}`;
    const field = { type: 'textarea', name, rows: node.rows || 3 };
    if (node.placeholder) field.placeholder = node.placeholder;
    if (node.required)    field.required = true;
    if (node.readonly)    field.readonly = true;
    if (node.styles?.width) field.width = this._parseDim(node.styles.width);

    ctx.fields.push({ name, fieldType: 'textarea', placeholder: field.placeholder, required: field.required });
    return field;
  },

  _genDatePicker(node, ctx) {
    const name = node.name || `date_${ctx.fieldIndex++}`;
    const field = { type: 'date-picker', name };
    if (node.placeholder) field.placeholder = node.placeholder;
    if (node.required)    field.required = true;
    if (node.readonly)    field.readonly = true;
    if (node.value)       field.value = node.value;
    if (node.min)         field.min = node.min;
    if (node.max)         field.max = node.max;

    ctx.fields.push({ name, fieldType: 'date-picker', required: field.required });
    return field;
  },

  _genSignature(node, ctx) {
    const name = node.name || `signature_${ctx.fieldIndex++}`;
    const field = { type: 'signature', name };
    if (node.width)  field.width  = this._parseDim(node.width);
    if (node.height) field.height = this._parseDim(node.height);
    if (node.value)  field.value = node.value;

    ctx.fields.push({ name, fieldType: 'signature' });
    return field;
  },

  _genImageUpload(node, ctx) {
    const name = node.name || `image_${ctx.fieldIndex++}`;
    const field = { type: 'image-upload', name };
    if (node.source && node.source !== 'both') field.source = node.source;
    if (node.width)    field.width  = this._parseDim(node.width);
    if (node.height)   field.height = this._parseDim(node.height);
    if (node.value)    field.value = node.value;
    if (node.required) field.required = true;

    ctx.fields.push({ name, fieldType: 'image-upload', required: field.required });
    return field;
  },

  _genCheckbox(node, ctx) {
    const name = node.name || `checkbox_${ctx.fieldIndex++}`;
    const field = { type: 'checkbox', name };
    if (node.label)    field.label = node.label;
    if (node.options && node.options.length) field.options = node.options;
    if (node.hasOther) field.other = true;
    if (node.value)    field.value = node.value;
    if (node.disabled) field.disabled = true;

    ctx.fields.push({ name, fieldType: 'checkbox' });
    return field;
  },

  _genRadio(node, ctx) {
    const name = node.name || `radio_${ctx.fieldIndex++}`;
    const field = { type: 'radio', name, options: node.options || [] };
    if (node.value)    field.value = node.value;
    if (node.required) field.required = true;
    if (node.disabled) field.disabled = true;

    ctx.fields.push({ name, fieldType: 'radio', required: field.required });
    return field;
  },

  _genFile(node, ctx) {
    const name = node.name || `file_${ctx.fieldIndex++}`;
    const field = { type: 'file', name };
    if (node.accept)   field.accept = node.accept;
    if (node.multiple) field.multiple = true;
    if (node.maxSize)  field.maxSize = node.maxSize;
    if (node.value)    field.value = node.value;
    if (node.required) field.required = true;

    ctx.fields.push({ name, fieldType: 'file', required: field.required });
    return field;
  },

  _genSearch(node, ctx) {
    const name = node.name || `search_${ctx.fieldIndex++}`;
    const field = { type: 'search', name, source: node.source || '' };
    if (node.display)     field.display = node.display;
    if (node.valueField)  field.valueField = node.valueField;
    if (node.fields)      field.fields = node.fields;
    if (node.placeholder) field.placeholder = node.placeholder;
    if (node.value)       field.value = node.value;
    if (node.required)    field.required = true;

    ctx.fields.push({ name, fieldType: 'search', required: field.required });
    return field;
  },

  _extractContainerStyle(styles) {
    const s = {};
    if (styles.backgroundColor) s.backgroundColor = styles.backgroundColor;
    if (styles.color)           s.color = styles.color;
    if (styles.fontSize)        s.fontSize = this._parseDim(styles.fontSize);
    if (styles.fontWeight)      s.fontWeight = styles.fontWeight;
    if (styles.fontFamily)      s.fontFamily = styles.fontFamily?.split(',')[0].trim().replace(/['"]/g, '');
    if (styles.textAlign)       s.textAlign = styles.textAlign;

    if (styles.width) {
      const dim = this._parseDim(styles.width);
      s.width = dim || 'infinity';
    } else {
      s.width = 'infinity';
    }
    if (styles.height) s.height = this._parseDim(styles.height);

    const padding = this._extractEdgeInsets(styles, 'padding');
    if (padding) s.padding = padding;
    const margin = this._extractEdgeInsets(styles, 'margin');
    if (margin) s.margin = margin;

    const border = this._extractBorder(styles);
    if (border) s.border = border;
    if (styles.borderRadius) s.borderRadius = this._parseDim(styles.borderRadius);

    return s;
  },

  _extractEdgeInsets(styles, prefix) {
    const top    = this._parseDim(styles[`${prefix}Top`]);
    const right  = this._parseDim(styles[`${prefix}Right`]);
    const bottom = this._parseDim(styles[`${prefix}Bottom`]);
    const left   = this._parseDim(styles[`${prefix}Left`]);
    if (top == null && right == null && bottom == null && left == null) return null;
    return { top: top || 0, right: right || 0, bottom: bottom || 0, left: left || 0 };
  },

  _extractBorder(styles) {
    const sides = {};
    for (const side of ['borderTop', 'borderBottom', 'borderLeft', 'borderRight']) {
      if (styles[side]) {
        const m = String(styles[side]).match(/([\d.]+)(?:px)?\s+\w+\s+(#[0-9a-fA-F]+|\w+)/);
        if (m) {
          sides[side.replace('border', '').toLowerCase()] = { width: parseFloat(m[1]), color: m[2] };
        }
      }
    }
    if (Object.keys(sides).length) return sides;

    if (styles.borderWidth && styles.borderColor) {
      const w = this._parseDim(styles.borderWidth) || 1;
      return { top: { width: w, color: styles.borderColor }, right: { width: w, color: styles.borderColor },
               bottom: { width: w, color: styles.borderColor }, left: { width: w, color: styles.borderColor } };
    }
    return null;
  },

  // Merge consecutive text nodes with same style into single text/richtext with \n separators.
  // Different styles stay separate (e.g. h1 + p remain in Column).
  _mergeConsecutiveTexts(nodes) {
    const isTextLike = (n) => (n.type === 'text' && !n.href) || n.type === 'richtext';

    const styleKey = (n) => {
      if (!n.style) return '';
      const s = n.style;
      return [s.fontSize || '', s.fontWeight || '', s.fontFamily || '', s.color || '', s.fontStyle || ''].join('|');
    };

    const result = [];
    let textRun = [];

    const flush = () => {
      if (textRun.length === 0) return;
      if (textRun.length === 1) { result.push(textRun[0]); textRun = []; return; }

      const allPlainText = textRun.every(n => n.type === 'text');
      if (allPlainText) {
        const contents = textRun.map(t => t.content || '');
        const merged = { type: 'text', content: contents.join('\n') };
        const firstStyle = textRun.find(t => t.style)?.style;
        if (firstStyle) merged.style = firstStyle;
        result.push(merged);
      } else {
        const spans = [];
        for (let i = 0; i < textRun.length; i++) {
          if (i > 0) spans.push({ text: '\n' });
          const n = textRun[i];
          if (n.type === 'text') {
            spans.push(n.style ? { text: n.content || '', style: n.style } : { text: n.content || '' });
          } else if (n.type === 'richtext') {
            spans.push(...(n.spans || []));
          }
        }
        result.push({ type: 'richtext', spans });
      }
      textRun = [];
    };

    for (const node of nodes) {
      if (isTextLike(node)) {
        if (textRun.length > 0) {
          const lastKey = styleKey(textRun[0]);
          const thisKey = styleKey(node);
          if (lastKey !== thisKey) {
            flush();
          }
        }
        textRun.push(node);
      } else {
        flush();
        result.push(node);
      }
    }
    flush();
    return result;
  },

  _extractAllText(node) {
    if (node.type === 'text') {
      return (node.content || '').replace(/[\r\n\t]+/g, ' ').replace(/ {2,}/g, ' ');
    }
    if (node.type === 'svg') return '';
    if (node.styles?.position === 'absolute') return '';
    let text = '';
    for (const c of (node.children || [])) text += this._extractAllText(c);
    return text.trim();
  },

  _collapseWS(s) {
    return (s || '').replace(/[\r\n\t]+/g, ' ').replace(/ {2,}/g, ' ');
  },

  _parseDim(str) {
    if (str == null) return null;
    if (typeof str === 'number') return str;
    const dim = StyleParser.parseDimension(str);
    if (!dim) return null;
    // pt → px (1pt = 1.33 logical pixels), rem/em → px (1rem = 16px)
    if (dim.unit === 'pt')  return Math.round(dim.value * 1.33 * 10) / 10;
    if (dim.unit === 'rem' || dim.unit === 'em') return Math.round(dim.value * 16 * 10) / 10;
    return dim.value;
  },
};

if (typeof window !== 'undefined') window.JsonGenerator = JsonGenerator;
if (typeof module !== 'undefined') module.exports = JsonGenerator;
