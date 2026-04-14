const App = {
  elements: {
    htmlInput: null,
    dartOutput: null,
    controllersOutput: null,
    stateOutput: null,
    importsOutput: null,
    boilerplateOutput: null,
    convertBtn: null,
    copyWidgetBtn: null,
    clearBtn: null,
    exampleBtns: null,
  },

  outputMode: 'dart',
  _lastResult: null,
  _lastJsonResult: null,

  init() {
    this.elements.htmlInput         = document.getElementById('htmlInput');
    this.elements.dartOutput        = document.getElementById('dartOutput');
    this.elements.controllersOutput = document.getElementById('controllersOutput');
    this.elements.stateOutput       = document.getElementById('stateOutput');
    this.elements.importsOutput     = document.getElementById('importsOutput');
    this.elements.boilerplateOutput = document.getElementById('boilerplateOutput');
    this.elements.convertBtn        = document.getElementById('convertBtn');
    this.elements.copyWidgetBtn = document.getElementById('copyWidgetBtn');
    this.elements.clearBtn = document.getElementById('clearBtn');
    this.elements.exampleBtns = document.querySelectorAll('[id^="example"]');

    this.bindEvents();
    this.bindTabEvents();
    this.bindModeToggle();
    this.loadExample('basic');
  },

  bindModeToggle() {
    const dartBtn = document.getElementById('modeDart');
    const jsonBtn = document.getElementById('modeJson');
    if (!dartBtn || !jsonBtn) return;

    dartBtn.addEventListener('click', () => {
      this.outputMode = 'dart';
      dartBtn.classList.add('active');
      jsonBtn.classList.remove('active');
      document.getElementById('outputTitle').textContent = 'main.dart';
      this.convert();
    });

    jsonBtn.addEventListener('click', () => {
      this.outputMode = 'json';
      jsonBtn.classList.add('active');
      dartBtn.classList.remove('active');
      document.getElementById('outputTitle').textContent = 'form.json';
      this.convert();
    });
  },

  bindTabEvents() {
    document.querySelectorAll('[data-tab]').forEach(btn => {
      btn.addEventListener('click', () => {
        document.querySelectorAll('[data-tab]').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
        btn.classList.add('active');
        const tabContent = document.getElementById(btn.dataset.tab + '-tab');
        if (tabContent) tabContent.classList.add('active');
      });
    });

    document.querySelectorAll('[data-input-tab]').forEach(btn => {
      btn.addEventListener('click', () => {
        document.querySelectorAll('[data-input-tab]').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.input-tab-content').forEach(t => t.classList.remove('active'));
        btn.classList.add('active');
        const tabContent = document.getElementById(btn.dataset.inputTab + '-tab');
        if (tabContent) tabContent.classList.add('active');
        if (btn.dataset.inputTab === 'preview') this.updatePreview();
      });
    });
  },

  updatePreview() {
    const preview = document.getElementById('htmlPreview');
    if (!preview) return;
    preview.innerHTML = this.elements.htmlInput.value;
  },

  bindEvents() {
    if (!this.elements.convertBtn) return;

    this.elements.convertBtn.addEventListener('click', () => this.convert());

    this.elements.copyWidgetBtn.addEventListener('click', () => {
      this.copyMainDart();
    });

    this.elements.clearBtn.addEventListener('click', () => this.clear());

    this.elements.exampleBtns.forEach(btn => {
      btn.addEventListener('click', () => {
        const example = btn.id.replace('example', '').toLowerCase();
        this.loadExample(example);
      });
    });

    let timeout;
    this.elements.htmlInput.addEventListener('input', () => {
      clearTimeout(timeout);
      timeout = setTimeout(() => this.convert(), 500);
    });

    this.elements.htmlInput.addEventListener('keydown', (e) => {
      if (e.ctrlKey && e.key === 'Enter') {
        this.convert();
      }
    });
  },

  inlineStyles(html) {
    if (!/<style[\s>]/i.test(html)) return html;
    try {
      return typeof juice !== 'undefined' ? juice(html) : html;
    } catch (e) {
      console.warn('juice inlining failed:', e);
      return html;
    }
  },

  convert() {
    const raw  = this.elements.htmlInput.value.trim();

    if (!raw) {
      this.showError('Please enter HTML code');
      return;
    }

    const html = this.inlineStyles(raw);

    try {
      const ast = HTMLParser.parse(html);

      if (this.outputMode === 'json') {
        const jsonResult = JsonGenerator.generate(ast);
        this._lastJsonResult = jsonResult;
        this.elements.dartOutput.textContent = JSON.stringify(jsonResult, null, 2);
        this.elements.controllersOutput.textContent = '';
        this.elements.stateOutput.textContent = '';
        this.elements.importsOutput.textContent = '';
        if (this.elements.boilerplateOutput) this.elements.boilerplateOutput.textContent = '';
      } else {
        const result = DartGenerator.generate(ast);
        this._lastResult = result;

        const completeDart = this._buildMainDartCode();
        this.elements.dartOutput.textContent        = completeDart || result.widgetCode;
        this.elements.controllersOutput.textContent = result.controllersCode  || '// No controllers needed';
        this.elements.stateOutput.textContent       = result.stateCode        || '// No state variables needed';
        this.elements.importsOutput.textContent     = result.importsCode      || 'import \'package:flutter/material.dart\';';
        if (this.elements.boilerplateOutput) {
          this.elements.boilerplateOutput.textContent = result.boilerplateCode || '// No helper classes needed';
        }
      }

      this.updatePreview();
      this.highlightCode();
      this.showSuccess('Converted successfully!');

    } catch (error) {
      console.error('Conversion error:', error);
      this.showError(`Error: ${error.message}`);
    }
  },

  async copyToClipboard(text, label = 'Code') {
    try {
      await navigator.clipboard.writeText(text);
      this.showSuccess(`${label} copied to clipboard!`);
    } catch (error) {
      this.showError('Failed to copy to clipboard');
    }
  },

  _buildMainDartCode() {
    if (!this._lastResult) return null;
    const r = this._lastResult;
    const imports     = (r.importsCode      || '').trim();
    const controllers = (r.controllersCode  || '').trim();
    const state       = (r.stateCode        || '').trim();
    const boilerplate = (r.boilerplateCode  || '').trim();
    const widgetCodes = (r.widgetCodes || [r.widgetCode]).map(w => (w || '').trim()).filter(Boolean);

    if (!widgetCodes.length || widgetCodes[0].startsWith('// Error')) return null;

    const ctrlLines  = (!controllers || controllers.startsWith('// No')) ? '' : controllers;
    const stateLines = (!state       || state.startsWith('// No'))       ? '' : state;
    let   bpCode     = (!boilerplate || boilerplate.startsWith('// No')) ? '' : boilerplate;

    const importSection = imports || "import 'package:flutter/material.dart';";
    const indent2 = (s) => s ? s.split('\n').map(l => l ? '  ' + l : '').join('\n') : '';
    const multiPage = widgetCodes.length > 1;

    const lines = [
      importSection,
      "import 'preview_shell.dart';",
      '',
    ];

    const needsStateful = ctrlLines || stateLines;

    if (multiPage) {
      const pageListItems = widgetCodes.map((_, i) => `    _page${i + 1}(),`).join('\n');
      if (!needsStateful) {
        lines.push('void main() => runApp(PreviewShell(pages: _pages()));');
        lines.push('');
        lines.push(`List<Widget> _pages() => [\n${pageListItems}\n];`);
        lines.push('');
        widgetCodes.forEach((raw, i) => {
          lines.push(`Widget _page${i + 1}() => ${raw.replace(/^child:\s*/, '')};`);
          lines.push('');
        });
      } else {
        const ctrlSection  = ctrlLines  ? '\n  // ============ CONTROLLERS ============\n' + indent2(ctrlLines)  + '\n' : '';
        const stateSection = stateLines ? '\n  // ============ STATE VARIABLES ============\n' + indent2(stateLines) + '\n' : '';
        const pageMethods  = widgetCodes.map((raw, i) =>
          `  Widget _page${i + 1}() => ${raw.replace(/^child:\s*/, '')};`
        ).join('\n\n');
        const pageListInBuild = widgetCodes.map((_, i) => `      _page${i + 1}(),`).join('\n');
        lines.push(
          'void main() => runApp(const _App());',
          '',
          'class _App extends StatefulWidget {',
          '  const _App({super.key});',
          '  @override',
          '  State<_App> createState() => _AppState();',
          '}',
          '',
          'class _AppState extends State<_App> {',
          ctrlSection,
          stateSection,
          '  @override',
          '  Widget build(BuildContext context) => PreviewShell(pages: [',
          pageListInBuild,
          '  ]);',
          '',
          pageMethods,
          '}',
        );
      }
    } else {
      const rawWidget = widgetCodes[0].replace(/^child:\s*/, '');
      if (!needsStateful) {
        lines.push('void main() => runApp(PreviewShell(pages: [_content()]));');
        lines.push('');
        lines.push(`Widget _content() => ${rawWidget};`);
      } else {
        const ctrlSection  = ctrlLines  ? '\n  // ============ CONTROLLERS ============\n' + indent2(ctrlLines)  + '\n' : '';
        const stateSection = stateLines ? '\n  // ============ STATE VARIABLES ============\n' + indent2(stateLines) + '\n' : '';
        lines.push(
          'void main() => runApp(PreviewShell(pages: [_ContentWidget()]));',
          '',
          'class _ContentWidget extends StatefulWidget {',
          '  const _ContentWidget({super.key});',
          '  @override',
          '  State<_ContentWidget> createState() => _ContentWidgetState();',
          '}',
          '',
          'class _ContentWidgetState extends State<_ContentWidget> {',
          ctrlSection,
          stateSection,
          '  @override',
          `  Widget build(BuildContext context) => ${rawWidget};`,
          '}',
        );
      }
    }

    if (bpCode) {
      lines.push('');
      lines.push('// ============ HELPER CLASSES ============');
      lines.push(bpCode);
    }

    return lines.join('\n');
  },

  exportOutput() {
    if (this.outputMode === 'json') {
      this.exportJson();
    } else {
      this.exportMainDart();
    }
  },

  exportMainDart() {
    const dartCode = this._buildMainDartCode();
    if (!dartCode) {
      this.showError('Convert HTML first before exporting');
      return;
    }

    const blob = new Blob([dartCode], { type: 'text/plain' });
    const url  = URL.createObjectURL(blob);
    const a    = document.createElement('a');
    a.href     = url;
    a.download = 'main.dart';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);

    this.showSuccess('main.dart downloaded! Drop into html_preview/lib/ then run: flutter run');
  },

  exportJson() {
    if (!this._lastJsonResult) {
      this.showError('Convert HTML first before exporting');
      return;
    }
    const json = JSON.stringify(this._lastJsonResult, null, 2);
    const blob = new Blob([json], { type: 'application/json' });
    const url  = URL.createObjectURL(blob);
    const a    = document.createElement('a');
    a.href     = url;
    a.download = 'form.json';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);

    this.showSuccess('form.json downloaded!');
  },

  copyMainDart() {
    if (this.outputMode === 'json') {
      if (!this._lastJsonResult) {
        this.showError('Convert HTML first before copying');
        return;
      }
      this.copyToClipboard(JSON.stringify(this._lastJsonResult, null, 2), 'JSON Schema');
      return;
    }
    const dartCode = this._buildMainDartCode();
    if (!dartCode) {
      this.showError('Convert HTML first before copying');
      return;
    }
    this.copyToClipboard(dartCode, 'Complete main.dart');
  },

  copyAll() {
    const imports     = this.elements.importsOutput?.textContent     || '';
    const controllers = this.elements.controllersOutput?.textContent || '';
    const state       = this.elements.stateOutput?.textContent       || '';
    const widget      = this.elements.dartOutput?.textContent        || '';
    const boilerplate = this.elements.boilerplateOutput?.textContent || '';

    const fullCode = `${imports}

// ============ Controllers ============
${controllers}

// ============ State Variables ============
${state}

// ============ Widget ============
${widget}

// ============ Helper Classes (file level) ============
${boilerplate}
`;

    this.copyToClipboard(fullCode, 'All code');
  },

  clear() {
    this._lastResult = null;
    this.elements.htmlInput.value = '';
    this.elements.dartOutput.textContent = '';
    this.elements.controllersOutput.textContent = '';
    this.elements.stateOutput.textContent = '';
    this.elements.importsOutput.textContent = '';
    if (this.elements.boilerplateOutput) this.elements.boilerplateOutput.textContent = '';
  },

  loadExample(name) {
    const example = Examples[name];
    if (example) {
      this.elements.htmlInput.value = example;
      this.convert();
    }
  },

  showSuccess(message) {
    this.showToast(message, 'success');
  },

  showError(message) {
    this.showToast(message, 'error');
    this.elements.dartOutput.textContent = `// Error: ${message}`;
  },

  showToast(message, type = 'info') {
    const existing = document.querySelector('.toast');
    if (existing) existing.remove();

    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.textContent = message;
    document.body.appendChild(toast);

    setTimeout(() => toast.classList.add('show'), 10);
    setTimeout(() => {
      toast.classList.remove('show');
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  },

  highlightCode() {}
};

const Examples = {
  basic: `<table border="1" cellpadding="8">
  <tr>
    <th>Field</th>
    <th>Value</th>
  </tr>
  <tr>
    <td>Name:</td>
    <td><input type="text" name="name" placeholder="Enter name" required /></td>
  </tr>
  <tr>
    <td>Email:</td>
    <td><input type="email" name="email" placeholder="Enter email" /></td>
  </tr>
</table>`,

  colspan: `<table border="1" cellpadding="10">
  <tr>
    <th colspan="3" bgcolor="#1976D2" style="color: white;">Customer Information</th>
  </tr>
  <tr>
    <td>Name:</td>
    <td colspan="2"><input type="text" name="customer_name" style="width: 300px;" /></td>
  </tr>
  <tr>
    <td>Phone:</td>
    <td><input type="tel" name="phone" /></td>
    <td><input type="text" name="ext" placeholder="Ext." style="width: 80px;" /></td>
  </tr>
  <tr>
    <td colspan="3" align="right">
      <b>Total: ฿1,234.00</b>
    </td>
  </tr>
</table>`,

  rowspan: `<table border="1" cellpadding="8">
  <tr>
    <th rowspan="2">Name</th>
    <th colspan="2">Score</th>
    <th rowspan="2">Total</th>
  </tr>
  <tr>
    <th>Math</th>
    <th>Science</th>
  </tr>
  <tr>
    <td>Alice</td>
    <td align="center">95</td>
    <td align="center">88</td>
    <td align="center"><b>183</b></td>
  </tr>
  <tr>
    <td>Bob</td>
    <td align="center">78</td>
    <td align="center">92</td>
    <td align="center"><b>170</b></td>
  </tr>
</table>`,

  form: `<div style="padding: 10px;">
  <h2>Service Report Form</h2>
  
  <table border="1" cellpadding="10">
    <thead>
      <tr>
        <th colspan="4" bgcolor="#388E3C" style="color: white;">Customer Details</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td width="120"><b>Customer:</b></td>
        <td><input type="text" name="customer" required /></td>
        <td width="100"><b>Job No:</b></td>
        <td><input type="text" name="job_no" /></td>
      </tr>
      <tr>
        <td><b>Address:</b></td>
        <td colspan="3"><input type="text" name="address" style="width: 400px;" /></td>
      </tr>
      <tr>
        <td><b>Start Date:</b></td>
        <td><date-picker name="start_date" /></td>
        <td><b>End Date:</b></td>
        <td><date-picker name="end_date" /></td>
      </tr>
      <tr>
        <td><b>Status:</b></td>
        <td>
          <select name="status">
            <option value="active">Active</option>
            <option value="pending">Pending</option>
            <option value="completed">Completed</option>
          </select>
        </td>
        <td><b>Priority:</b></td>
        <td>
          <select name="priority">
            <option value="low">Low</option>
            <option value="medium">Medium</option>
            <option value="high">High</option>
          </select>
        </td>
      </tr>
    </tbody>
  </table>

  <br />

  <table border="1" cellpadding="8">
    <tr>
      <th colspan="2" bgcolor="#F57C00" style="color: white;">Notes</th>
    </tr>
    <tr>
      <td colspan="2">
        <textarea name="notes" rows="4" placeholder="Enter notes here..." style="width: 100%;"></textarea>
      </td>
    </tr>
  </table>

  <br />

  <table border="1" cellpadding="10">
    <tr>
      <th bgcolor="#455A64" style="color: white;">Staff Signature</th>
      <th bgcolor="#455A64" style="color: white;">Customer Signature</th>
    </tr>
    <tr>
      <td align="center"><signature name="staff_sign" width="180" height="80" /></td>
      <td align="center"><signature name="customer_sign" width="180" height="80" /></td>
    </tr>
  </table>
</div>`,

  parts: `<table border="1" cellpadding="6" cellspacing="0">
  <thead>
    <tr bgcolor="#1976D2">
      <th style="color: white; width: 40px;">#</th>
      <th style="color: white; width: 120px;">Parts Code</th>
      <th style="color: white; width: 200px;">Parts Name</th>
      <th style="color: white; width: 60px;">Qty</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center">1</td>
      <td><input type="text" name="part_code_1" style="width: 100px;" /></td>
      <td><input type="text" name="part_name_1" style="width: 180px;" /></td>
      <td><input type="number" name="part_qty_1" style="width: 50px;" /></td>
    </tr>
    <tr bgcolor="#f5f5f5">
      <td align="center">2</td>
      <td><input type="text" name="part_code_2" style="width: 100px;" /></td>
      <td><input type="text" name="part_name_2" style="width: 180px;" /></td>
      <td><input type="number" name="part_qty_2" style="width: 50px;" /></td>
    </tr>
    <tr>
      <td align="center">3</td>
      <td><input type="text" name="part_code_3" style="width: 100px;" /></td>
      <td><input type="text" name="part_name_3" style="width: 180px;" /></td>
      <td><input type="number" name="part_qty_3" style="width: 50px;" /></td>
    </tr>
    <tr bgcolor="#f5f5f5">
      <td align="center">4</td>
      <td><input type="text" name="part_code_4" style="width: 100px;" /></td>
      <td><input type="text" name="part_name_4" style="width: 180px;" /></td>
      <td><input type="number" name="part_qty_4" style="width: 50px;" /></td>
    </tr>
  </tbody>
  <tfoot>
    <tr bgcolor="#e0e0e0">
      <td colspan="3" align="right"><b>Total:</b></td>
      <td align="center"><b>0</b></td>
    </tr>
  </tfoot>
</table>`,

  luckysheet: `<table style="border-collapse: collapse; font-family: Arial, sans-serif; font-size: 11pt; table-layout: fixed;">
  <colgroup>
    <col style="width: 120px;">
    <col style="width: 160px;">
    <col style="width: 160px;">
    <col style="width: 120px;">
  </colgroup>
  <tr style="height: 24px;">
    <td data-cell="Sheet1:A1" style="padding: 2px 4px; box-sizing: border-box; font-weight: bold; background-color: #1976D2; color: white; text-align: center; vertical-align: middle; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; border-bottom: 1px solid #0d47a1; position: relative;" colspan="4">Sales Report Q1 2024</td>
  </tr>
  <tr style="height: 22px;">
    <td data-cell="Sheet1:A2" style="padding: 2px 4px; box-sizing: border-box; font-weight: bold; background-color: #e3f2fd; text-align: left; vertical-align: middle; white-space: nowrap; border: 1px solid #90caf9; position: relative;">Product</td>
    <td data-cell="Sheet1:B2" style="padding: 2px 4px; box-sizing: border-box; font-weight: bold; background-color: #e3f2fd; text-align: center; vertical-align: middle; white-space: nowrap; border: 1px solid #90caf9; position: relative;">Sales</td>
    <td data-cell="Sheet1:C2" style="padding: 2px 4px; box-sizing: border-box; font-weight: bold; background-color: #e3f2fd; text-align: center; vertical-align: middle; white-space: nowrap; border: 1px solid #90caf9; position: relative;">Revenue</td>
    <td data-cell="Sheet1:D2" style="padding: 2px 4px; box-sizing: border-box; font-weight: bold; background-color: #e3f2fd; text-align: center; vertical-align: middle; white-space: nowrap; border: 1px solid #90caf9; position: relative;">Status</td>
  </tr>
  <tr style="height: 22px;">
    <td data-cell="Sheet1:A3" style="padding: 2px 4px; box-sizing: border-box; text-align: left; vertical-align: middle; white-space: nowrap; border: 1px solid #ccc; position: relative;">Widget A</td>
    <td data-cell="Sheet1:B3" style="padding: 2px 4px; box-sizing: border-box; background: linear-gradient(to right, #63c3f5 78%, transparent 78%); text-align: right; vertical-align: middle; white-space: nowrap; border: 1px solid #ccc; position: relative;">78</td>
    <td data-cell="Sheet1:C3" style="padding: 2px 4px; box-sizing: border-box; text-align: right; vertical-align: middle; white-space: nowrap; border: 1px solid #ccc; position: relative;">&#36;12,450.00</td>
    <td data-cell="Sheet1:D3" style="padding: 2px 4px; box-sizing: border-box; background-color: #63be7b; text-align: center; vertical-align: middle; white-space: nowrap; border: 1px solid #ccc; position: relative;"><span style="margin-right: 4px;">&#11014;&#65039;</span>High</td>
  </tr>
  <tr style="height: 22px;">
    <td data-cell="Sheet1:A4" style="padding: 2px 4px; box-sizing: border-box; text-align: left; vertical-align: middle; white-space: nowrap; border: 1px solid #ccc; position: relative;">Widget B</td>
    <td data-cell="Sheet1:B4" style="padding: 2px 4px; box-sizing: border-box; background: linear-gradient(to right, #63c3f5 45%, transparent 45%); text-align: right; vertical-align: middle; white-space: nowrap; border: 1px solid #ccc; position: relative;">45</td>
    <td data-cell="Sheet1:C4" style="padding: 2px 4px; box-sizing: border-box; text-align: right; vertical-align: middle; white-space: nowrap; border: 1px solid #ccc; position: relative;">&#36;7,200.00</td>
    <td data-cell="Sheet1:D4" style="padding: 2px 4px; box-sizing: border-box; background-color: #ffeb84; text-align: center; vertical-align: middle; white-space: nowrap; border: 1px solid #ccc; position: relative;"><span style="margin-right: 4px;">&#10145;&#65039;</span>Mid</td>
  </tr>
  <tr style="height: 22px;">
    <td data-cell="Sheet1:A5" style="padding: 2px 4px; box-sizing: border-box; text-align: left; vertical-align: middle; white-space: nowrap; border: 1px solid #ccc; position: relative;">Widget C</td>
    <td data-cell="Sheet1:B5" style="padding: 2px 4px; box-sizing: border-box; background: linear-gradient(to right, #63c3f5 22%, transparent 22%); text-align: right; vertical-align: middle; white-space: nowrap; border: 1px solid #ccc; position: relative;">22</td>
    <td data-cell="Sheet1:C5" style="padding: 2px 4px; box-sizing: border-box; text-align: right; vertical-align: middle; white-space: nowrap; border: 1px solid #ccc; position: relative;">&#36;3,100.00</td>
    <td data-cell="Sheet1:D5" style="padding: 2px 4px; box-sizing: border-box; background-color: #f8696b; color: white; text-align: center; vertical-align: middle; white-space: nowrap; border: 1px solid #ccc; position: relative;"><span style="margin-right: 4px;">&#11015;&#65039;</span>Low</td>
  </tr>
  <tr style="height: 22px;">
    <td data-cell="Sheet1:A6" style="padding: 2px 4px; box-sizing: border-box; font-weight: bold; text-align: left; vertical-align: middle; white-space: nowrap; border-top: 2px solid #333; border-bottom: 1px solid #ccc; border-left: 1px solid #ccc; border-right: 1px solid #ccc; position: relative;">Total</td>
    <td data-cell="Sheet1:B6" style="padding: 2px 4px; box-sizing: border-box; font-weight: bold; text-align: right; vertical-align: middle; white-space: nowrap; border-top: 2px solid #333; border-bottom: 1px solid #ccc; border-left: 1px solid #ccc; border-right: 1px solid #ccc; position: relative;">145</td>
    <td data-cell="Sheet1:C6" style="padding: 2px 4px; box-sizing: border-box; font-weight: bold; text-align: right; vertical-align: middle; white-space: nowrap; border-top: 2px solid #333; border-bottom: 1px solid #ccc; border-left: 1px solid #ccc; border-right: 1px solid #ccc; position: relative;">&#36;22,750.00</td>
    <td data-cell="Sheet1:D6" style="padding: 2px 4px; box-sizing: border-box; text-align: center; vertical-align: middle; white-space: nowrap; border-top: 2px solid #333; border-bottom: 1px solid #ccc; border-left: 1px solid #ccc; border-right: 1px solid #ccc; position: relative;"></td>
  </tr>
</table>`,

  nutrition: `<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Nutrition Facts</title>
</head>
<body style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">

<table width="280" cellpadding="0" cellspacing="0" style="border: 1px solid black; margin: 20px; padding: 8px;">
    <tr>
        <td colspan="5" style="font-weight: bold; font-size: 24px; border-bottom: 10px solid black; padding-bottom: 4px;">
            Nutrition Facts
        </td>
    </tr>
    <tr>
        <td colspan="5" style="border-bottom: 1px solid black; padding: 2px 0;">
            Serving Size 1/2 cup (about 82g)<br>
            Serving Per Container 8
        </td>
    </tr>

    <tr>
        <td colspan="5" style="font-size: 10px; font-weight: bold; padding-top: 4px;">Amount Per Serving</td>
    </tr>
    <tr>
        <td colspan="3" style="border-top: 1px solid black; font-size: 14px;"><b>Calories</b> 200</td>
        <td colspan="2" style="border-top: 1px solid black; text-align: right;">Calories from Fat 130</td>
    </tr>

    <tr>
        <td colspan="5" style="border-top: 5px solid black; font-size: 10px; text-align: right; font-weight: bold; padding-bottom: 2px;">
            % Daily Value*
        </td>
    </tr>

    <tr>
        <td colspan="4" style="border-top: 1px solid black;"><b>Total Fat</b> 14g</td>
        <td style="border-top: 1px solid black; text-align: right;"><b>22%</b></td>
    </tr>
    <tr>
        <td width="15">&nbsp;</td>
        <td colspan="3" style="border-top: 1px solid black;">Saturated Fat 9g</td>
        <td style="border-top: 1px solid black; text-align: right;"><b>22%</b></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td colspan="3" style="border-top: 1px solid black;">Trans Fat 0g</td>
        <td style="border-top: 1px solid black;">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="4" style="border-top: 1px solid black;"><b>Cholesterol</b> 55mg</td>
        <td style="border-top: 1px solid black; text-align: right;"><b>18%</b></td>
    </tr>
    <tr>
        <td colspan="4" style="border-top: 1px solid black;"><b>Sodium</b> 40mg</td>
        <td style="border-top: 1px solid black; text-align: right;"><b>2%</b></td>
    </tr>
    <tr>
        <td colspan="4" style="border-top: 1px solid black;"><b>Total Carbohydrate</b> 17g</td>
        <td style="border-top: 1px solid black; text-align: right;"><b>6%</b></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td colspan="3" style="border-top: 1px solid black;">Dietary Fiber 1g</td>
        <td style="border-top: 1px solid black; text-align: right;"><b>4%</b></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td colspan="3" style="border-top: 1px solid black;">Sugars 14g</td>
        <td style="border-top: 1px solid black;">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="4" style="border-top: 1px solid black; border-bottom: 10px solid black; padding-bottom: 4px;"><b>Protein</b> 3g</td>
        <td style="border-top: 1px solid black; border-bottom: 10px solid black;">&nbsp;</td>
    </tr>

    <tr>
        <td colspan="3" style="padding-top: 4px;">Vitamin A 10%</td>
        <td colspan="2" style="padding-top: 4px; text-align: right;">Vitamin C 0%</td>
    </tr>
    <tr>
        <td colspan="3" style="border-bottom: 1px solid black; padding-bottom: 4px;">Calcium 10%</td>
        <td colspan="2" style="border-bottom: 1px solid black; padding-bottom: 4px; text-align: right;">Iron 6%</td>
    </tr>

    <tr>
        <td colspan="5" style="font-size: 10px; padding: 4px 0;">
            * Percent Daily Values are based on a 2,000 calorie diet.
        </td>
    </tr>

    <tr style="font-size: 10px;">
        <td colspan="2">&nbsp;</td>
        <td style="border-bottom: 1px solid black;">Calories:</td>
        <td style="border-bottom: 1px solid black;">2,000</td>
        <td style="border-bottom: 1px solid black;">2,500</td>
    </tr>
    <tr style="font-size: 10px;">
        <td colspan="2"><b>Total Fat</b></td>
        <td>Less than</td>
        <td>65g</td>
        <td>80g</td>
    </tr>
    <tr style="font-size: 10px;">
        <td>&nbsp;</td>
        <td>Saturated Fat</td>
        <td>Less than</td>
        <td>20g</td>
        <td>25g</td>
    </tr>
    <tr style="font-size: 10px;">
        <td colspan="2"><b>Cholesterol</b></td>
        <td>Less than</td>
        <td>300mg</td>
        <td>300mg</td>
    </tr>
    <tr style="font-size: 10px;">
        <td colspan="2"><b>Sodium</b></td>
        <td>Less than</td>
        <td>2,400mg</td>
        <td>2,400mg</td>
    </tr>
    <tr style="font-size: 10px;">
        <td colspan="3"><b>Total Carbohydrate</b></td>
        <td>300g</td>
        <td>375g</td>
    </tr>
    <tr style="font-size: 10px;">
        <td>&nbsp;</td>
        <td colspan="2">Dietary Fiber</td>
        <td>25g</td>
        <td>30g</td>
    </tr>

    <tr>
        <td colspan="5" style="font-size: 10px; padding-top: 8px;">
            Calories per gram:<br>
            <div style="text-align: center;">Fat 9 &bull; Carbohydrate 4 &bull; Protein 4</div>
        </td>
    </tr>
</table>

</body>
</html>`,

  html4full: `<table border="2" cellpadding="10" cellspacing="0" width="600" bgcolor="#fafafa"
       frame="box" rules="all" summary="Complete HTML4 Table Example">
  <caption align="top"><b>HTML4 Table Specification Demo</b></caption>
  
  <colgroup>
    <col width="100" align="left" />
    <col width="150" align="center" />
    <col width="200" align="left" />
  </colgroup>
  
  <thead>
    <tr bgcolor="#333333" valign="middle">
      <th style="color: white;" scope="col">Header 1</th>
      <th style="color: white;" scope="col">Header 2</th>
      <th style="color: white;" scope="col">Header 3</th>
    </tr>
  </thead>
  
  <tfoot>
    <tr bgcolor="#cccccc">
      <td colspan="3" align="center"><i>Footer Row</i></td>
    </tr>
  </tfoot>
  
  <tbody>
    <tr valign="top">
      <td rowspan="2" bgcolor="#e3f2fd"><b>Merged Cell</b></td>
      <td align="center">Center</td>
      <td align="right">Right aligned</td>
    </tr>
    <tr>
      <td nowrap>No wrap text here</td>
      <td height="50" valign="bottom">Bottom aligned</td>
    </tr>
    <tr bgcolor="#fff3e0">
      <td headers="h1">With headers attr</td>
      <td abbr="abbreviated">Full text with abbr</td>
      <td><input type="text" name="input_field" placeholder="Input here" /></td>
    </tr>
  </tbody>
</table>`
};

document.addEventListener('DOMContentLoaded', () => {
  App.init();
});

function copyToClipboard(text, label = 'Code') {
  App.copyToClipboard(text, label);
}
