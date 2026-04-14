class ASTNode {
  constructor(type) {
    this.type = type;
    this.children = [];
    this.attributes = {};
    this.styles = {};
  }
}

class DocumentNode extends ASTNode {
  constructor() { super('document'); }
}

class ElementNode extends ASTNode {
  constructor(tagName) {
    super('element');
    this.tagName = tagName.toLowerCase();
  }
}

class TextNode extends ASTNode {
  constructor(content) {
    super('text');
    this.content = TextNode.normalize(content);
  }

  static normalize(text) {
    if (!text) return '';
    // Collapse HTML source whitespace: newlines, tabs, multiple spaces → single space, then trim
    let result = '';
    let prevSpace = false;
    for (let i = 0; i < text.length; i++) {
      const ch = text.charCodeAt(i);
      // \n=10, \r=13, \t=9, space=32
      if (ch === 10 || ch === 13 || ch === 9 || ch === 32) {
        if (!prevSpace) { result += ' '; prevSpace = true; }
      } else {
        result += text[i];
        prevSpace = false;
      }
    }
    return result.trim();
  }
}

class SVGNode extends ASTNode {
  constructor() {
    super('svg');
    this.diagonalLines = [];
  }
}

class TableNode extends ASTNode {
  constructor() {
    super('table');
    this.border = null;
    this.cellPadding = null;
    this.cellSpacing = null;
    this.width = null;
    this.height = null;
    this.bgcolor = null;
    this.align = null;
    this.frame = null;
    this.rules = null;
    this.summary = null;
  }
}

class TableRowNode extends ASTNode {
  constructor() {
    super('tr');
    this.align = null;
    this.valign = null;
    this.bgcolor = null;
    this.char = null;
    this.charoff = null;
  }
}

class TableCellNode extends ASTNode {
  constructor(isHeader = false) {
    super(isHeader ? 'th' : 'td');
    this.isHeader = isHeader;
    this.colspan = 1;
    this.rowspan = 1;
    this.align = null;
    this.valign = null;
    this.bgcolor = null;
    this.width = null;
    this.height = null;
    this.nowrap = false;
    this.headers = null;
    this.scope = null;
    this.abbr = null;
    this.axis = null;
    this.char = null;
    this.charoff = null;
    this.dataCell = null;
  }
}

class TableSectionNode extends ASTNode {
  constructor(sectionType) {
    super(sectionType);
    this.align = null;
    this.valign = null;
    this.char = null;
    this.charoff = null;
  }
}

class TableCaptionNode extends ASTNode {
  constructor() {
    super('caption');
    this.align = null;
  }
}

class ColGroupNode extends ASTNode {
  constructor() {
    super('colgroup');
    this.span = 1;
    this.width = null;
    this.align = null;
    this.valign = null;
    this.char = null;
    this.charoff = null;
  }
}

class ColNode extends ASTNode {
  constructor() {
    super('col');
    this.span = 1;
    this.width = null;
    this.align = null;
    this.valign = null;
    this.char = null;
    this.charoff = null;
  }
}

class InputNode extends ASTNode {
  constructor() {
    super('input');
    this.inputType = 'text';
    this.name = '';
    this.placeholder = '';
    this.required = false;
    this.readonly = false;
    this.disabled = false;
    this.value = '';
    this.pattern = null;
  }
}

class SelectNode extends ASTNode {
  constructor() {
    super('select');
    this.name = '';
    this.required = false;
    this.disabled = false;
    this.multiple = false;
    this.options = [];
  }
}

class OptionNode extends ASTNode {
  constructor() {
    super('option');
    this.value = '';
    this.selected = false;
    this.disabled = false;
    this.label = '';
  }
}

class TextAreaNode extends ASTNode {
  constructor() {
    super('textarea');
    this.name = '';
    this.placeholder = '';
    this.rows = 3;
    this.cols = 20;
    this.required = false;
    this.readonly = false;
    this.disabled = false;
  }
}

class DatePickerNode extends ASTNode {
  constructor() {
    super('date-picker');
    this.name = '';
    this.placeholder = '';
    this.required = false;
    this.readonly = false;
    this.value = '';
    this.min = null;
    this.max = null;
  }
}

class SignatureNode extends ASTNode {
  constructor() {
    super('signature');
    this.name = '';
    this.width = null;
    this.height = null;
    this.value = '';
  }
}

class ImageUploadNode extends ASTNode {
  constructor() {
    super('image-upload');
    this.name = '';
    this.source = 'both'; // 'upload', 'camera', 'both'
    this.width = null;
    this.height = null;
    this.value = '';
    this.required = false;
  }
}

class CheckboxNode extends ASTNode {
  constructor() {
    super('checkbox');
    this.name = '';
    this.label = null;
    this.options = [];
    this.hasOther = false;
    this.value = null;
    this.disabled = false;
  }
}

class RadioNode extends ASTNode {
  constructor() {
    super('radio');
    this.name = '';
    this.options = [];
    this.value = '';
    this.required = false;
    this.disabled = false;
  }
}

class FileUploadNode extends ASTNode {
  constructor() {
    super('file');
    this.name = '';
    this.accept = null;
    this.multiple = false;
    this.maxSize = null;
    this.value = '';
    this.required = false;
  }
}

class SearchNode extends ASTNode {
  constructor() {
    super('search');
    this.name = '';
    this.source = '';
    this.display = null;
    this.valueField = null;
    this.fields = null;
    this.placeholder = '';
    this.value = '';
    this.required = false;
  }
}

const ASTNodes = {
  ASTNode,
  DocumentNode,
  ElementNode,
  TextNode,
  SVGNode,
  TableNode,
  TableRowNode,
  TableCellNode,
  TableSectionNode,
  TableCaptionNode,
  ColGroupNode,
  ColNode,
  InputNode,
  SelectNode,
  OptionNode,
  TextAreaNode,
  DatePickerNode,
  SignatureNode,
  ImageUploadNode,
  CheckboxNode,
  RadioNode,
  FileUploadNode,
  SearchNode,
};

if (typeof window !== 'undefined') window.ASTNodes = ASTNodes;
if (typeof module !== 'undefined') module.exports = ASTNodes;
