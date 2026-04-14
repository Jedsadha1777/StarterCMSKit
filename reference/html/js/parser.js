const HTMLParser = {
  parse(html) {
    const doc = new ASTNodes.DocumentNode();
    const parser = new DOMParser();
    const dom = parser.parseFromString(html, 'text/html');
    const body = dom.body;
    if (body) {
      const bodyStyle = body.getAttribute('style');
      if (bodyStyle) doc.bodyStyles = StyleParser.parse(bodyStyle);
      for (const child of body.childNodes) {
        const node = this.parseNode(child);
        if (node) doc.children.push(node);
      }
    }
    return doc;
  },

  parseNode(domNode) {
    if (!domNode) return null;
    if (domNode.nodeType === Node.TEXT_NODE) {
      const text = domNode.textContent;
      if (text.trim()) {
        const bracket = this.parseBracketTag(text.trim());
        if (bracket) return bracket;
        return new ASTNodes.TextNode(text);
      }
      return null;
    }
    if (domNode.nodeType === Node.ELEMENT_NODE) {
      return this.parseElement(domNode);
    }
    return null;
  },

  parseElement(element) {
    const tagName = element.tagName.toLowerCase();
    let node;

    switch (tagName) {
      case 'table':    node = this.parseTable(element); break;
      case 'tr':       node = this.parseTableRow(element); break;
      case 'td':
      case 'th':       node = this.parseTableCell(element, tagName === 'th'); break;
      case 'thead':
      case 'tbody':
      case 'tfoot':    node = this.parseTableSection(element, tagName); break;
      case 'caption':  node = this.parseCaption(element); break;
      case 'colgroup': node = this.parseColGroup(element); break;
      case 'col':      node = this.parseCol(element); break;
      case 'input':    node = this.parseInput(element); break;
      case 'select':   node = this.parseSelect(element); break;
      case 'option':   node = this.parseOption(element); break;
      case 'textarea': node = this.parseTextArea(element); break;
      case 'date-picker':  node = this.parseDatePicker(element); break;
      case 'signature':    node = this.parseSignature(element); break;
      case 'image-upload': node = this.parseImageUpload(element); break;
      case 'svg':      node = this.parseSVG(element); break;
      default:         node = new ASTNodes.ElementNode(tagName); break;
    }

    this.parseCommonAttributes(element, node);

    const voidElements = ['input', 'col', 'br', 'hr', 'img', 'svg'];
    // Note: <pagebreak> is intentionally NOT void — browser nests subsequent content
    // inside it, so we need to read its children and hoist them into the next page.
    if (!voidElements.includes(tagName)) {
      for (const child of element.childNodes) {
        const childNode = this.parseNode(child);
        if (childNode) node.children.push(childNode);
      }
    }

    return node;
  },

  parseCommonAttributes(element, node) {
    for (const attr of element.attributes) {
      node.attributes[attr.name.toLowerCase()] = attr.value;
    }
    const style = element.getAttribute('style');
    if (style) node.styles = StyleParser.parse(style);
    node.className = element.className || '';
    node.id = element.id || '';
  },

  parseSVG(element) {
    const node = new ASTNodes.SVGNode();
    for (const line of element.querySelectorAll('line')) {
      node.diagonalLines.push({
        x1: line.getAttribute('x1') || '0',
        y1: line.getAttribute('y1') || '0',
        x2: line.getAttribute('x2') || '100%',
        y2: line.getAttribute('y2') || '100%',
        stroke: line.getAttribute('stroke') || '#000000',
        strokeWidth: parseFloat(line.getAttribute('stroke-width') || '1'),
      });
    }
    return node;
  },

  parseTable(element) {
    const node = new ASTNodes.TableNode();
    node.border      = this.getAttrInt(element, 'border');
    node.cellPadding = this.getAttrValue(element, 'cellpadding');
    node.cellSpacing = this.getAttrValue(element, 'cellspacing');
    node.width       = this.getAttrValue(element, 'width');
    node.height      = this.getAttrValue(element, 'height');
    node.bgcolor     = this.getAttrValue(element, 'bgcolor');
    node.align       = this.getAttrValue(element, 'align');
    node.frame       = this.getAttrValue(element, 'frame');
    node.rules       = this.getAttrValue(element, 'rules');
    node.summary     = this.getAttrValue(element, 'summary');
    return node;
  },

  parseTableRow(element) {
    const node = new ASTNodes.TableRowNode();
    node.align   = this.getAttrValue(element, 'align');
    node.valign  = this.getAttrValue(element, 'valign');
    node.bgcolor = this.getAttrValue(element, 'bgcolor');
    node.char    = this.getAttrValue(element, 'char');
    node.charoff = this.getAttrValue(element, 'charoff');
    return node;
  },

  parseTableCell(element, isHeader) {
    const node = new ASTNodes.TableCellNode(isHeader);
    node.colspan  = this.getAttrInt(element, 'colspan', 1);
    node.rowspan  = this.getAttrInt(element, 'rowspan', 1);
    node.align    = this.getAttrValue(element, 'align');
    node.valign   = this.getAttrValue(element, 'valign');
    node.bgcolor  = this.getAttrValue(element, 'bgcolor');
    node.width    = this.getAttrValue(element, 'width');
    node.height   = this.getAttrValue(element, 'height');
    node.nowrap   = element.hasAttribute('nowrap');
    node.headers  = this.getAttrValue(element, 'headers');
    node.scope    = this.getAttrValue(element, 'scope');
    node.abbr     = this.getAttrValue(element, 'abbr');
    node.axis     = this.getAttrValue(element, 'axis');
    node.char     = this.getAttrValue(element, 'char');
    node.charoff  = this.getAttrValue(element, 'charoff');
    node.dataCell = this.getAttrValue(element, 'data-cell');
    return node;
  },

  parseTableSection(element, sectionType) {
    const node = new ASTNodes.TableSectionNode(sectionType);
    node.align   = this.getAttrValue(element, 'align');
    node.valign  = this.getAttrValue(element, 'valign');
    node.char    = this.getAttrValue(element, 'char');
    node.charoff = this.getAttrValue(element, 'charoff');
    return node;
  },

  parseCaption(element) {
    const node = new ASTNodes.TableCaptionNode();
    node.align = this.getAttrValue(element, 'align');
    return node;
  },

  parseColGroup(element) {
    const node = new ASTNodes.ColGroupNode();
    node.span    = this.getAttrInt(element, 'span', 1);
    node.width   = this.getAttrValue(element, 'width');
    node.align   = this.getAttrValue(element, 'align');
    node.valign  = this.getAttrValue(element, 'valign');
    node.char    = this.getAttrValue(element, 'char');
    node.charoff = this.getAttrValue(element, 'charoff');
    return node;
  },

  parseCol(element) {
    const node = new ASTNodes.ColNode();
    node.span    = this.getAttrInt(element, 'span', 1);
    node.width   = this.getAttrValue(element, 'width');
    node.align   = this.getAttrValue(element, 'align');
    node.valign  = this.getAttrValue(element, 'valign');
    node.char    = this.getAttrValue(element, 'char');
    node.charoff = this.getAttrValue(element, 'charoff');
    return node;
  },

  parseInput(element) {
    const node = new ASTNodes.InputNode();
    node.inputType   = this.getAttrValue(element, 'type') || 'text';
    node.name        = this.getAttrValue(element, 'name') || '';
    node.placeholder = this.getAttrValue(element, 'placeholder') || '';
    node.value       = this.getAttrValue(element, 'value') || '';
    node.required    = element.hasAttribute('required');
    node.readonly    = element.hasAttribute('readonly');
    node.disabled    = element.hasAttribute('disabled');
    return node;
  },

  parseSelect(element) {
    const node = new ASTNodes.SelectNode();
    node.name     = this.getAttrValue(element, 'name') || '';
    node.required = element.hasAttribute('required');
    node.disabled = element.hasAttribute('disabled');
    node.multiple = element.hasAttribute('multiple');
    return node;
  },

  parseOption(element) {
    const node = new ASTNodes.OptionNode();
    node.value    = this.getAttrValue(element, 'value') || element.textContent.trim();
    node.selected = element.hasAttribute('selected');
    node.disabled = element.hasAttribute('disabled');
    node.label    = element.textContent.trim();
    return node;
  },

  parseTextArea(element) {
    const node = new ASTNodes.TextAreaNode();
    node.name        = this.getAttrValue(element, 'name') || '';
    node.placeholder = this.getAttrValue(element, 'placeholder') || '';
    node.rows        = this.getAttrInt(element, 'rows', 3);
    node.cols        = this.getAttrInt(element, 'cols', 20);
    node.required    = element.hasAttribute('required');
    node.readonly    = element.hasAttribute('readonly');
    node.disabled    = element.hasAttribute('disabled');
    return node;
  },

  parseDatePicker(element) {
    const node = new ASTNodes.DatePickerNode();
    node.name        = this.getAttrValue(element, 'name') || '';
    node.placeholder = this.getAttrValue(element, 'placeholder') || '';
    node.required    = element.hasAttribute('required');
    return node;
  },

  parseSignature(element) {
    const node = new ASTNodes.SignatureNode();
    node.name   = this.getAttrValue(element, 'name') || '';
    node.width  = this.getAttrValue(element, 'width');
    node.height = this.getAttrValue(element, 'height');
    return node;
  },

  parseImageUpload(element) {
    const node = new ASTNodes.ImageUploadNode();
    node.name   = this.getAttrValue(element, 'name') || '';
    node.width  = this.getAttrValue(element, 'width');
    node.height = this.getAttrValue(element, 'height');
    return node;
  },

  // ── Bracket Tag Parser ──────────────────────────────────
  // Parses text like: [input* name type="email" placeholder="hint"]
  // Returns AST node or null if not a bracket tag
  parseBracketTag(text) {
    const match = text.match(/^\[([\w-]+\*?)\s+(.+)\]$/s);
    if (!match) return null;

    let typeRaw = match[1];
    const body = match[2];

    const required = typeRaw.endsWith('*');
    const type = required ? typeRaw.slice(0, -1) : typeRaw;

    const { name, attrs, options } = this._parseBracketBody(body);
    if (!name) return null;

    switch (type) {
      case 'input':    return this._buildInputNode(name, required, attrs);
      case 'textarea': return this._buildTextareaNode(name, required, attrs);
      case 'select':   return this._buildSelectNode(name, required, attrs, options);
      case 'checkbox': return this._buildCheckboxNode(name, attrs, options);
      case 'radio':    return this._buildRadioNode(name, required, attrs, options);
      case 'date':     return this._buildDateNode(name, required, attrs);
      case 'signature':return this._buildSignatureNode(name, attrs);
      case 'image-upload': return this._buildImageUploadNode(name, required, attrs);
      case 'file':     return this._buildFileNode(name, required, attrs);
      case 'search':   return this._buildSearchNode(name, required, attrs);
      default:         return null;
    }
  },

  // Parse bracket body: name key="val" flag "opt1" "opt2"
  _parseBracketBody(body) {
    const attrs = {};
    const options = [];
    let name = null;

    // Regex to match: key="val", "quoted option", flag word
    const regex = /(\w[\w\-]*)="([^"]*)"|"([^"]*)"|(\S+)/g;
    let m;
    let first = true;

    while ((m = regex.exec(body)) !== null) {
      if (m[1] && m[2] !== undefined) {
        // key="value"
        attrs[m[1]] = m[2];
      } else if (m[3] !== undefined) {
        // "quoted option"
        options.push(m[3]);
      } else if (m[4]) {
        if (first) {
          name = m[4];
          first = false;
        } else {
          // flag like: readonly, disabled, other, first_as_label, multiple
          attrs[m[4]] = true;
        }
      }
    }

    return { name, attrs, options };
  },

  _buildInputNode(name, required, attrs) {
    const node = new ASTNodes.InputNode();
    node.name        = name;
    node.inputType   = attrs.type || 'text';
    node.placeholder = attrs.placeholder || '';
    node.value       = attrs.value || '';
    node.pattern     = attrs.pattern || null;
    node.required    = required;
    node.readonly    = attrs.readonly === true;
    node.disabled    = attrs.disabled === true;
    return node;
  },

  _buildTextareaNode(name, required, attrs) {
    const node = new ASTNodes.TextAreaNode();
    node.name        = name;
    node.placeholder = attrs.placeholder || '';
    node.rows        = parseInt(attrs.rows) || 3;
    node.value       = attrs.value || '';
    node.required    = required;
    node.readonly    = attrs.readonly === true;
    node.disabled    = attrs.disabled === true;
    return node;
  },

  _buildSelectNode(name, required, attrs, options) {
    const node = new ASTNodes.SelectNode();
    node.name        = name;
    node.required    = required;
    node.disabled    = attrs.disabled === true;
    node.firstAsLabel = attrs.first_as_label === true;
    node.value       = attrs.value || '';
    // Build option children
    for (const opt of options) {
      const optNode = new ASTNodes.OptionNode();
      optNode.value = opt;
      optNode.label = opt;
      node.children.push(optNode);
    }
    return node;
  },

  _buildCheckboxNode(name, attrs, options) {
    const node = new ASTNodes.CheckboxNode();
    node.name     = name;
    node.label    = attrs.label || null;
    node.options  = options;
    node.hasOther = attrs.other === true;
    node.value    = attrs.value || null;
    node.disabled = attrs.disabled === true;
    return node;
  },

  _buildRadioNode(name, required, attrs, options) {
    const node = new ASTNodes.RadioNode();
    node.name     = name;
    node.options  = options;
    node.value    = attrs.value || '';
    node.required = required;
    node.disabled = attrs.disabled === true;
    return node;
  },

  _buildDateNode(name, required, attrs) {
    const node = new ASTNodes.DatePickerNode();
    node.name        = name;
    node.placeholder = attrs.placeholder || '';
    node.value       = attrs.value || '';
    node.min         = attrs.min || null;
    node.max         = attrs.max || null;
    node.required    = required;
    node.readonly    = attrs.readonly === true;
    return node;
  },

  _buildSignatureNode(name, attrs) {
    const node = new ASTNodes.SignatureNode();
    node.name   = name;
    node.width  = attrs.width || null;
    node.height = attrs.height || null;
    node.value  = attrs.value || '';
    return node;
  },

  _buildImageUploadNode(name, required, attrs) {
    const node = new ASTNodes.ImageUploadNode();
    node.name     = name;
    node.source   = attrs.source || 'both';
    node.width    = attrs.width || null;
    node.height   = attrs.height || null;
    node.value    = attrs.value || '';
    node.required = required;
    return node;
  },

  _buildFileNode(name, required, attrs) {
    const node = new ASTNodes.FileUploadNode();
    node.name     = name;
    node.accept   = attrs.accept || null;
    node.multiple = attrs.multiple === true;
    node.maxSize  = parseInt(attrs['max-size']) || null;
    node.value    = attrs.value || '';
    node.required = required;
    return node;
  },

  _buildSearchNode(name, required, attrs) {
    const node = new ASTNodes.SearchNode();
    node.name        = name;
    node.source      = attrs.source || '';
    node.display     = attrs.display || null;
    node.valueField  = attrs.value || null;
    node.fields      = attrs.fields || null;
    node.placeholder = attrs.placeholder || '';
    node.required    = required;
    return node;
  },

  // ── End Bracket Tag Parser ────────────────────────────

  getAttrValue(element, name) {
    return element.getAttribute(name) || null;
  },

  getAttrInt(element, name, defaultValue = null) {
    const value = element.getAttribute(name);
    if (value === null) return defaultValue;
    const parsed = parseInt(value, 10);
    return isNaN(parsed) ? defaultValue : parsed;
  },
};

if (typeof window !== 'undefined') window.HTMLParser = HTMLParser;
if (typeof module !== 'undefined') module.exports = HTMLParser;
