(function () {
    'use strict';

    function invoke(method, args) {
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod(method, args || []);
    }

    function node(tag, className, value) {
        const result = document.createElement(tag);
        if (className) result.className = className;
        if (value !== undefined && value !== null) result.textContent = value;
        return result;
    }

    function installStyles() {
        if (document.getElementById('ufc-si-dashboard-styles')) return;

        const styles = document.createElement('style');
        styles.id = 'ufc-si-dashboard-styles';
        styles.textContent = `
:root { color: #11284b; font-family: "Segoe UI", Arial, sans-serif; }
* { box-sizing: border-box; }
html, body { width: 100%; max-width: 100%; min-width: 0; overflow-x: hidden; }
body { margin: 0; background: #f5f8fc; }
button { font: inherit; }
.desk { width: 100%; max-width: 100%; min-height: 100%; padding: 10px 14px 14px; overflow-x: hidden; background: linear-gradient(135deg, #f8fbff 0%, #fff 56%, #f4f9ff 100%); }
.header { display: flex; justify-content: space-between; gap: 14px; align-items: flex-start; margin-bottom: 8px; }
h1, h2, p { margin: 0; }
h1 { font-size: 26px; line-height: 1.1; letter-spacing: -.65px; color: #102a50; }
h2 { font-size: 18px; line-height: 1.2; color: #132b50; }
.badges { display: flex; align-items: center; gap: 8px; margin-top: 5px; }
.direction, .pull, .status { display: inline-flex; align-items: center; border-radius: 999px; font-size: 13px; font-weight: 700; }
.direction { padding: 4px 10px; background: #e6f1ff; color: #1264cc; }
.pull { padding: 4px 10px; background: #e8f8ef; color: #13824a; }
.actions { display: flex; flex-wrap: wrap; justify-content: flex-end; gap: 8px; }
.action { display: inline-flex; align-items: center; gap: 8px; min-height: 34px; padding: 0 12px; color: #17325a; background: #fff; border: 1px solid #cdd9e9; border-radius: 7px; cursor: pointer; font-size: 13px; font-weight: 650; box-shadow: 0 1px 2px rgba(19,51,96,.04); }
.action:hover, .action:focus-visible { border-color: #2381e6; background: #f4f9ff; outline: 2px solid transparent; }
.primary { color: #fff; border-color: #0a74dc; background: linear-gradient(180deg, #1685ef, #086fd6); }
.primary:hover, .primary:focus-visible { color: #fff; background: #0569cd; }
.action-icon { font-size: 18px; line-height: 1; }
.notice { display: flex; align-items: center; gap: 10px; padding: 9px 13px; color: #175784; background: #e9f7ff; border: 1px solid #c5e8fa; border-radius: 8px; font-size: 13px; font-weight: 600; }
.notice-icon { display: grid; place-items: center; width: 20px; height: 20px; border-radius: 50%; color: #fff; background: #1476cc; font-family: Georgia, serif; font-weight: 700; }
.stage-kpis { display: grid; grid-template-columns: repeat(5, minmax(0, 1fr)); gap: 9px; width: 100%; max-width: 100%; margin-top: 9px; }.stage-kpi { display: grid; grid-template-columns: 34px minmax(0, 1fr); align-items: center; gap: 9px; min-width: 0; min-height: 67px; padding: 10px 12px; background: #fff; border: 1px solid #d7e2f0; border-radius: 9px; box-shadow: 0 2px 8px rgba(23,54,98,.04); }.stage-kpi-icon { display: grid; place-items: center; width: 34px; height: 34px; border-radius: 50%; font-size: 17px; font-weight: 800; }.stage-kpi-copy { min-width: 0; }.stage-kpi-label { overflow: hidden; color: #465f80; font-size: 11px; font-weight: 750; text-overflow: ellipsis; white-space: nowrap; }.stage-kpi-value { margin-top: 2px; color: #173a6d; font-size: 23px; font-weight: 800; line-height: 1; }.stage-ready .stage-kpi-icon { color: #0b70d7; background: #e5f0ff; }.stage-progress .stage-kpi-icon { color: #a16900; background: #fff0d4; }.stage-errors .stage-kpi-icon { color: #dd3948; background: #ffe7ea; }.stage-created .stage-kpi-icon { color: #0c8d58; background: #e3f7eb; }.stage-total .stage-kpi-icon { color: #585fbb; background: #eeedff; }.stage-errors .stage-kpi-value { color: #df3948; }.stage-created .stage-kpi-value { color: #0c8d58; }
.pipeline { display: grid; grid-template-columns: repeat(4, minmax(0,1fr)); width: 100%; max-width: 100%; margin-top: 9px; padding: 10px 12px 8px; overflow: hidden; background: #fff; border: 1px solid #d7e2f0; border-radius: 10px; box-shadow: 0 2px 8px rgba(23,54,98,.04); }
.pipeline-step { position: relative; display: flex; align-items: flex-start; gap: 10px; min-width: 0; }
.pipeline-step:not(:last-child)::after { position: absolute; top: 17px; left: 37px; right: 6px; height: 3px; background: #cfd8e5; content: ""; }
.pipeline-step.done:not(:last-child)::after { background: #16a66a; }
.pipeline-step.current:not(:last-child)::after, .pipeline-step.error:not(:last-child)::after { background: #cfd8e5; }
.pipeline-marker { z-index: 1; display: grid; place-items: center; flex: 0 0 34px; width: 34px; height: 34px; border: 2px solid #becbdd; border-radius: 50%; color: #fff; background: #fff; font-size: 13px; font-weight: 800; }
.done .pipeline-marker { border-color: #0d9660; background: #0d9660; }
.current .pipeline-marker { border-color: #0e7be8; background: #0e7be8; }
.error .pipeline-marker { border-color: #e34b55; background: #e34b55; }
.pipeline-copy { display: grid; gap: 3px; min-width: 0; overflow: hidden; }
.pipeline-copy strong { overflow-wrap: anywhere; font-size: 15px; color: #122d53; }
.pipeline-copy span { overflow-wrap: anywhere; color: #687a94; font-size: 12px; }
.panels { display: grid; grid-template-columns: repeat(2, minmax(0,1fr)); gap: 12px; width: 100%; max-width: 100%; margin-top: 9px; }
.work-area { display: grid; grid-template-columns: minmax(0, 1.65fr) minmax(300px, .95fr); align-items: start; gap: 12px; width: 100%; max-width: 100%; margin-top: 9px; }.work-area .entries-panel, .work-area .panels { margin-top: 0; }.work-area .panels { grid-template-columns: 1fr; }
.panel, .entries-panel { background: #fff; border: 1px solid #d7e2f0; border-radius: 10px; box-shadow: 0 2px 8px rgba(23,54,98,.04); }
.panel { min-width: 0; min-height: 160px; padding: 13px 16px; }
.attention { border-color: #f0cbd1; background: linear-gradient(135deg, #fff8f9 0%, #fff 64%); }
.panel-title { display: flex; align-items: center; gap: 10px; }
.symbol { display: grid; place-items: center; width: 30px; height: 30px; border-radius: 50%; color: #fff; font-weight: 800; }
.error-symbol { background: #e34b55; }.ready-symbol { background: #1386e8; }
.summary { display: flex; align-items: flex-end; gap: 12px; margin-top: 13px; }
.summary strong { font-size: 42px; line-height: .9; letter-spacing: -1.5px; }.error-summary strong { color: #e23f4b; }.ready-summary strong { color: #0c78e1; }
.summary span { max-width: 240px; color: #425773; font-size: 14px; line-height: 1.35; }
.panel-note { min-height: 30px; margin-top: 9px; color: #5e718b; font-size: 12px; line-height: 1.35; }
.attention .action { min-height: 26px; margin-top: 4px; padding: 0; border: 0; color: #0c75db; background: transparent; box-shadow: none; }
.ready .primary { width: 100%; margin-top: 11px; }
.metrics { display: grid; grid-template-columns: repeat(4,minmax(0,1fr)); gap: 9px; margin-top: 10px; padding-top: 9px; border-top: 1px solid #dde5ef; }
.metric { display: grid; gap: 3px; padding-left: 10px; border-left: 1px solid #dce4ef; }.metric:first-child { padding-left: 0; border-left: 0; }
.metric strong { color: #172d4d; font-size: 18px; }.metric span { color: #70819a; font-size: 11px; }
.entries-panel { display: flex; flex-direction: column; width: 100%; max-width: 100%; margin-top: 9px; overflow: hidden; }.entries-heading { display: flex; justify-content: space-between; align-items: baseline; gap: 12px; padding: 10px 16px 8px; }.entries-heading span { color: #657894; font-size: 12px; }
.entry-list { max-height: 160px; overflow-y: auto; }.entry-table { width: 100%; border-collapse: collapse; table-layout: fixed; }.entry-table th { position: sticky; top: 0; z-index: 1; padding: 8px 12px; color: #5d708d; background: #f3f7fb; border-top: 1px solid #dce5f0; border-bottom: 1px solid #dce5f0; font-size: 11px; font-weight: 700; text-align: left; }.entry-table td { overflow: hidden; padding: 9px 12px; color: #1e3559; border-bottom: 1px solid #e4ebf3; font-size: 12px; text-overflow: ellipsis; white-space: nowrap; }
.entry-row { cursor: pointer; }.entry-row:hover, .entry-row:focus-visible { background: #edf6ff; outline: none; }.status { padding: 4px 10px; font-size: 12px; }.open { color: #0d69cf; background: #e2f0ff; }.success { color: #08733f; background: #ddf7e8; }.processing { color: #a96500; background: #fff1d5; }.failed { color: #c62938; background: #ffe2e5; }.validation { color: #0a8a4e; font-size: 12px; font-weight: 700; }.validation.invalid { color: #cf3542; }.received { color: #627691; }.empty-row td { padding: 29px 15px; color: #6a7c93; text-align: center; }
@media (max-width: 1250px) { .pipeline { grid-template-columns: 1fr 1fr; }.pipeline-step:nth-child(2)::after { display: none; } }
@media (max-width: 850px) { .desk { padding: 14px; }.header, .entries-heading { align-items: flex-start; flex-direction: column; }.actions { justify-content: flex-start; }.pipeline, .panels { grid-template-columns: 1fr; }.pipeline-step::after { display: none; }.metrics { grid-template-columns: 1fr 1fr; }.entry-table { min-width: 620px; } }
@media (max-width: 850px) { .work-area { grid-template-columns: 1fr; }.work-area .panels { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
@media (max-height: 600px) {
    .desk { padding: 6px 8px 8px; }
    .header, .notice { display: none; }
    .stage-kpis { gap: 6px; margin-top: 0; }.stage-kpi { grid-template-columns: 26px minmax(0, 1fr); min-height: 49px; padding: 6px; }.stage-kpi-icon { width: 26px; height: 26px; font-size: 13px; }.stage-kpi-label { font-size: 9px; }.stage-kpi-value { margin-top: 0; font-size: 19px; }
    .pipeline { grid-template-columns: repeat(4, minmax(0, 1fr)); margin-top: 0; padding: 6px 8px; }
    .pipeline-step { gap: 6px; }.pipeline-step:not(:last-child)::after { top: 12px; left: 28px; right: 4px; }
    .pipeline-marker { flex-basis: 26px; width: 26px; height: 26px; font-size: 11px; }
    .pipeline-copy span { display: none; }.pipeline-copy strong { font-size: 11px; }
    .panels { grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 7px; margin-top: 7px; }
    .panel { min-height: 92px; padding: 9px; }.panel-title { gap: 7px; }.symbol { width: 25px; height: 25px; }
    .summary { gap: 8px; margin-top: 7px; }.summary strong { font-size: 32px; }.summary span { font-size: 11px; line-height: 1.2; }
    .panel-note { display: none; }.attention .panel-note { display: block; min-height: 0; margin-top: 4px; font-size: 10px; line-height: 1.25; }.attention .action { display: inline-flex; min-height: 18px; margin-top: 3px; font-size: 10px; }.ready .primary { min-height: 28px; margin-top: 7px; }
    .metrics { gap: 5px; margin-top: 7px; padding-top: 6px; }.metric { padding-left: 5px; }.metric strong { font-size: 14px; }.metric span { font-size: 9px; }
    .entries-panel { margin-top: 7px; }.entries-heading { padding: 6px 10px; }.entries-heading h2 { font-size: 14px; }.entries-heading span { display: none; }
    .entry-list { max-height: 250px; }.entry-table th { padding: 6px 8px; font-size: 10px; }.entry-table td { padding: 7px 8px; font-size: 11px; }.status { padding: 3px 6px; font-size: 10px; }
    .work-area { grid-template-columns: minmax(0, 1.45fr) minmax(0, 1fr); gap: 7px; margin-top: 7px; }.work-area .panels { grid-template-columns: 1fr; gap: 6px; }.work-area .panel { min-height: 0; padding: 7px 9px; }.work-area .panel-title h2 { font-size: 13px; }.work-area .summary { gap: 6px; margin-top: 4px; }.work-area .summary strong { font-size: 28px; }.work-area .summary span { overflow: hidden; font-size: 10px; line-height: 1.1; text-overflow: ellipsis; white-space: nowrap; }.work-area .attention .panel-note { margin-top: 2px; overflow: hidden; font-size: 9px; line-height: 1.1; text-overflow: ellipsis; white-space: nowrap; }.work-area .attention .action { min-height: 14px; margin-top: 1px; font-size: 9px; }.work-area .ready .primary { min-height: 24px; margin-top: 3px; font-size: 10px; }.work-area .metrics { display: none; }
}
`;
        document.head.appendChild(styles);
    }

    function button(label, icon, action, primary) {
        const result = node('button', primary ? 'action primary' : 'action');
        result.type = 'button';
        result.appendChild(node('span', 'action-icon', icon));
        result.appendChild(node('span', '', label));
        result.addEventListener('click', function () { invoke(action); });
        return result;
    }

    function statusClass(value) {
        const status = String(value || '').toLowerCase();
        if (status === 'success') return 'success';
        if (status === 'failed') return 'failed';
        if (status === 'processing') return 'processing';
        return 'open';
    }

    function pipelineStep(label, detail, state) {
        const result = node('div', 'pipeline-step ' + state);
        result.appendChild(node('span', 'pipeline-marker', state === 'done' ? '✓' : state === 'current' ? '•••' : state === 'error' ? '!' : ''));
        const copy = node('div', 'pipeline-copy');
        copy.appendChild(node('strong', '', label));
        copy.appendChild(node('span', '', detail));
        result.appendChild(copy);
        return result;
    }

    function quantity(value) {
        return Number(value) || 0;
    }

    function recordText(count, singular, plural) {
        return count + ' ' + (count === 1 ? singular : plural);
    }

    function getWorkflow(model) {
        const ready = quantity(model.ready);
        const failed = quantity(model.failed);
        const processing = quantity(model.processing);
        const success = quantity(model.success);
        const total = quantity(model.total);

        if (total === 0) {
            return {
                notice: 'The dashboard is ready. It is waiting for i6 to send the EOD invoice payload.',
                pull: { detail: 'Waiting for i6 EOD payload', state: 'pending' },
                validate: { detail: 'Starts after i6 sends data', state: 'pending' },
                store: { detail: 'No records to store', state: 'pending' },
                create: { detail: 'Awaiting staged invoices', state: 'pending' }
            };
        }

        const workflow = {
            pull: { detail: recordText(total, 'invoice received', 'invoices received'), state: 'done' },
            validate: { detail: 'Mandatory checks completed', state: 'done' },
            store: { detail: 'No open entries', state: 'done' },
            create: { detail: 'Internal BC processing complete', state: 'done' }
        };

        if (failed > 0) {
            workflow.validate = { detail: recordText(failed, 'record requires review', 'records require review'), state: 'error' };
            workflow.notice = recordText(failed, 'staging record requires attention.', 'staging records require attention.');
            if (ready === 0 && processing === 0 && success === 0) {
                workflow.store = { detail: 'No valid records available', state: 'error' };
                workflow.create = { detail: 'Resolve errors before processing', state: 'pending' };
            }
        }

        if (ready > 0) {
            workflow.store = { detail: recordText(ready, 'record ready for processing', 'records ready for processing'), state: 'current' };
            workflow.create = { detail: 'Waiting for internal BC processing', state: 'pending' };
            if (failed === 0)
                workflow.notice = recordText(ready, 'validated staging record is ready for processing.', 'validated staging records are ready for processing.');
        }

        if (processing > 0) {
            workflow.store = { detail: 'Staging records handed to BC', state: 'done' };
            workflow.create = { detail: recordText(processing, 'invoice is being created', 'invoices are being created'), state: 'current' };
            if (failed === 0)
                workflow.notice = recordText(processing, 'sales invoice is being created in Business Central.', 'sales invoices are being created in Business Central.');
        }

        if (success > 0) {
            workflow.create = {
                detail: ready > 0 || processing > 0
                    ? recordText(success, 'invoice created', 'invoices created')
                    : recordText(success, 'sales invoice created successfully', 'sales invoices created successfully'),
                state: ready > 0 || processing > 0 ? workflow.create.state : 'done'
            };
            if (failed === 0 && ready === 0 && processing === 0)
                workflow.notice = recordText(success, 'sales invoice was created successfully.', 'sales invoices were created successfully.');
        }

        if (!workflow.notice)
            workflow.notice = 'Staging status is up to date.';

        return workflow;
    }

    function metric(label, value) {
        const result = node('div', 'metric');
        result.appendChild(node('strong', '', String(value || 0)));
        result.appendChild(node('span', '', label));
        return result;
    }

    function stageKpi(kind, icon, label, value) {
        const result = node('article', 'stage-kpi stage-' + kind);
        result.appendChild(node('span', 'stage-kpi-icon', icon));
        const copy = node('div', 'stage-kpi-copy');
        copy.appendChild(node('div', 'stage-kpi-label', label));
        copy.appendChild(node('div', 'stage-kpi-value', String(value || 0)));
        result.appendChild(copy);
        return result;
    }

    function renderEntries(container, entries) {
        const table = node('table', 'entry-table');
        const thead = node('thead');
        const headerRow = node('tr');
        ['Entry', 'Invoice No.', 'Customer', 'Location', 'Status', 'Validation', 'Received'].forEach(function (heading) {
            headerRow.appendChild(node('th', '', heading));
        });
        thead.appendChild(headerRow);
        table.appendChild(thead);
        const tbody = node('tbody');

        if (!entries || entries.length === 0) {
            const emptyRow = node('tr', 'empty-row');
            const emptyCell = node('td', '', 'No staging entries yet. Pull i6 data to begin processing.');
            emptyCell.colSpan = 7;
            emptyRow.appendChild(emptyCell);
            tbody.appendChild(emptyRow);
        } else {
            entries.forEach(function (entry) {
                const row = node('tr', 'entry-row');
                row.tabIndex = 0;
                row.addEventListener('click', function () { invoke('OpenEntry', [entry.entryNo]); });
                row.addEventListener('keydown', function (event) {
                    if (event.key === 'Enter' || event.key === ' ') {
                        event.preventDefault();
                        invoke('OpenEntry', [entry.entryNo]);
                    }
                });
                [entry.entryNo, entry.invoiceId, entry.customerNo, entry.locationCode].forEach(function (value) {
                    row.appendChild(node('td', '', value || '—'));
                });
                const statusCell = node('td');
                statusCell.appendChild(node('span', 'status ' + statusClass(entry.status), entry.status || 'Open'));
                row.appendChild(statusCell);
                const invalid = String(entry.status || '').toLowerCase() === 'failed';
                row.appendChild(node('td', invalid ? 'validation invalid' : 'validation', invalid ? '● Error' : '● Ready'));
                row.appendChild(node('td', 'received', entry.receivedAt || '—'));
                tbody.appendChild(row);
            });
        }
        table.appendChild(tbody);
        const list = node('div', 'entry-list');
        list.appendChild(table);
        container.appendChild(list);
    }

    window.RenderDashboard = function (dashboardJson) {
        installStyles();
        let model;
        try {
            model = JSON.parse(dashboardJson);
        } catch (error) {
            model = { ready: 0, failed: 0, processing: 0, success: 0, total: 0, errorLogCount: 0, preStagingErrorCount: 0, entries: [] };
        }
        const workflow = getWorkflow(model);
        const loggedErrorCount = quantity(model.errorLogCount);
        const failedStagingCount = quantity(model.failed);
        const preStagingErrorCount = quantity(model.preStagingErrorCount);

        document.body.replaceChildren();
        const desk = node('main', 'desk');
        desk.setAttribute('aria-label', 'Sales Invoice Staging operations desk');

        const header = node('header', 'header');
        const titles = node('div');
        titles.appendChild(node('h1', '', 'Sales Invoice Staging'));
        const badges = node('div', 'badges');
        badges.appendChild(node('span', 'direction', 'i6 → BC'));
        badges.appendChild(node('span', 'pull', '● EOD push-based integration'));
        titles.appendChild(badges);
        header.appendChild(titles);
        const actions = node('div', 'actions');
        actions.appendChild(button('Process Ready', '▷', 'ProcessReady'));
        actions.appendChild(button('Review Errors', '⚠', 'ReviewErrors'));
        actions.appendChild(button('Open Staging', '☷', 'OpenStaging'));
        header.appendChild(actions);
        desk.appendChild(header);

        const notice = node('div', 'notice');
        notice.appendChild(node('span', 'notice-icon', 'i'));
        notice.appendChild(node('span', '', workflow.notice));
        desk.appendChild(notice);

        const kpis = node('section', 'stage-kpis');
        kpis.appendChild(stageKpi('ready', '▣', 'Ready to Process', model.ready));
        kpis.appendChild(stageKpi('progress', '↻', 'In Progress', model.processing));
        kpis.appendChild(stageKpi('errors', '!', 'Error Log', loggedErrorCount));
        kpis.appendChild(stageKpi('created', '✓', 'Created', model.success));
        kpis.appendChild(stageKpi('total', '≡', 'Total in Staging', model.total));
        desk.appendChild(kpis);

        const workArea = node('section', 'work-area');
        const entriesPanel = node('section', 'entries-panel');
        const entriesHeading = node('div', 'entries-heading');
        entriesHeading.appendChild(node('h2', '', 'Recent Staging Entries'));
        entriesHeading.appendChild(node('span', '', 'Select an entry for details; scroll the list to view more recent entries'));
        entriesPanel.appendChild(entriesHeading);
        renderEntries(entriesPanel, model.entries);
        workArea.appendChild(entriesPanel);

        const panels = node('section', 'panels');
        const attention = node('article', 'panel attention');
        const attentionTitle = node('div', 'panel-title');
        attentionTitle.appendChild(node('span', 'symbol error-symbol', '!'));
        attentionTitle.appendChild(node('h2', '', 'Attention Required'));
        attention.appendChild(attentionTitle);
        const errorSummary = node('div', 'summary error-summary');
        errorSummary.appendChild(node('strong', '', String(loggedErrorCount)));
        errorSummary.appendChild(node('span', '', 'total Error Log entries'));
        attention.appendChild(errorSummary);
        attention.appendChild(node('p', 'panel-note', failedStagingCount > 0
            ? recordText(failedStagingCount, 'staging record', 'staging records') + ' failed. ' + (preStagingErrorCount === 1 ? '1 pull/import issue was logged before staging.' : String(preStagingErrorCount) + ' pull/import issues were logged before staging.')
            : loggedErrorCount > 0
                ? 'No staging records are currently failed. Previous Error Log entries are retained for audit.'
                : 'No logged integration issues require attention.'));
        if (failedStagingCount > 0)
            attention.appendChild(button('Reset Failed (' + failedStagingCount + ')', '↻', 'ResetFailed'));
        attention.appendChild(button('Review Errors', '→', 'ReviewErrors'));
        panels.appendChild(attention);

        const ready = node('article', 'panel ready');
        const readyTitle = node('div', 'panel-title');
        readyTitle.appendChild(node('span', 'symbol ready-symbol', '✓'));
        readyTitle.appendChild(node('h2', '', 'Ready to Process'));
        ready.appendChild(readyTitle);
        const readySummary = node('div', 'summary ready-summary');
        readySummary.appendChild(node('strong', '', String(model.ready || 0)));
        readySummary.appendChild(node('span', '', 'validated staging records ready for invoice creation'));
        ready.appendChild(readySummary);
        ready.appendChild(button('Process Ready', '▷', 'ProcessReady', true));
        const metrics = node('div', 'metrics');
        metrics.appendChild(metric('Total in staging', model.total));
        metrics.appendChild(metric('Ready', model.ready));
        metrics.appendChild(metric('Failed staging', model.failed));
        metrics.appendChild(metric('Processing', model.processing));
        ready.appendChild(metrics);
        panels.appendChild(ready);
        workArea.appendChild(panels);
        desk.appendChild(workArea);
        document.body.appendChild(desk);
    };

    function installOptionOneStyles() {
        if (document.getElementById('ufc-si-option-one-styles')) return;

        const styles = document.createElement('style');
        styles.id = 'ufc-si-option-one-styles';
        styles.textContent = [
            ':root { color: #102a50; font-family: "Segoe UI", Arial, sans-serif; }',
            '* { box-sizing: border-box; }',
            'html, body { width: 100%; max-width: 100%; min-width: 0; overflow-x: hidden; }',
            'body { margin: 0; background: #eef5fb; }',
            'button { font: inherit; }',
            '.o1-dashboard { width: 100%; min-height: 100%; padding: 20px; background: linear-gradient(135deg, #f6fbff 0%, #ffffff 54%, #edf8f5 100%); }',
            '.o1-hero { display: flex; align-items: flex-start; justify-content: space-between; gap: 18px; }',
            '.o1-hero h1, .o1-section h2, .o1-hero p { margin: 0; }',
            '.o1-hero h1 { color: #0e2c57; font-size: 28px; letter-spacing: -.5px; line-height: 1.1; }',
            '.o1-hero p { margin-top: 5px; color: #647793; font-size: 14px; }',
            '.o1-actions { display: flex; flex-wrap: wrap; justify-content: flex-end; gap: 8px; }',
            '.o1-button { display: inline-flex; align-items: center; justify-content: center; gap: 7px; min-height: 38px; padding: 0 13px; color: #17365e; background: #ffffff; border: 1px solid #cbd8e8; border-radius: 8px; box-shadow: 0 1px 2px rgba(20,55,94,.06); cursor: pointer; font-size: 13px; font-weight: 700; }',
            '.o1-button:hover, .o1-button:focus-visible { border-color: #167fea; background: #f2f8ff; outline: 2px solid transparent; }',
            '.o1-button-primary { color: #ffffff; border-color: #0874df; background: linear-gradient(180deg, #198af2, #0871da); }',
            '.o1-button-primary:hover, .o1-button-primary:focus-visible { color: #ffffff; background: #0668c9; }',
            '.o1-button:disabled, .o1-button.is-disabled { cursor: not-allowed; opacity: .56; filter: grayscale(.15); }',
            '.o1-button-icon { font-size: 16px; line-height: 1; }',
            '.o1-alert { display: flex; align-items: center; gap: 10px; margin-top: 14px; padding: 11px 14px; color: #126b3e; background: linear-gradient(90deg, #e4f8ed, #f4fdf8); border: 1px solid #c1ebd1; border-radius: 8px; font-size: 13px; font-weight: 650; }',
            '.o1-alert.pending { color: #8c5e10; background: linear-gradient(90deg, #fff5dd, #fffbf2); border-color: #f0d99a; }',
            '.o1-alert-mark { display: grid; place-items: center; flex: 0 0 21px; width: 21px; height: 21px; border-radius: 50%; color: #ffffff; background: #16a262; font-weight: 800; }',
            '.o1-alert.pending .o1-alert-mark { background: #d39116; }',
            '.o1-kpis { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; margin-top: 14px; }',
            '.o1-kpi { display: grid; grid-template-columns: 47px minmax(0, 1fr); align-items: center; gap: 11px; min-width: 0; min-height: 93px; padding: 14px; background: #ffffff; border: 1px solid #dae5f0; border-radius: 10px; box-shadow: 0 3px 10px rgba(25,62,106,.06); }',
            '.o1-kpi-icon { display: grid; place-items: center; width: 47px; height: 47px; border-radius: 50%; font-size: 23px; font-weight: 800; }',
            '.o1-kpi-copy { min-width: 0; }.o1-kpi-label { overflow-wrap: anywhere; color: #233c61; font-size: 13px; font-weight: 750; }',
            '.o1-kpi-value { margin-top: 2px; color: #112f5b; font-size: 30px; font-weight: 800; line-height: 1; }.o1-kpi-note { margin-top: 4px; color: #71829b; font-size: 11px; }',
            '.o1-ready .o1-kpi-icon { color: #0f71d8; background: #e7f1ff; }.o1-progress .o1-kpi-icon { color: #9c6500; background: #fff2d8; }.o1-errors .o1-kpi-icon { color: #de3746; background: #ffe8eb; }.o1-created .o1-kpi-icon { color: #0d9460; background: #e4f8ec; }',
            '.o1-errors .o1-kpi-value { color: #df3847; }.o1-created .o1-kpi-value { color: #0f8b59; }',
            '.o1-main { display: grid; grid-template-columns: minmax(0, 2.05fr) minmax(280px, .95fr); gap: 14px; margin-top: 14px; }',
            '.o1-section { min-width: 0; background: #ffffff; border: 1px solid #d6e3f0; border-radius: 10px; box-shadow: 0 3px 10px rgba(25,62,106,.06); overflow: hidden; }',
            '.o1-section-head { display: flex; align-items: center; justify-content: space-between; gap: 12px; padding: 13px 15px 10px; }',
            '.o1-section h2 { color: #112f5b; font-size: 18px; line-height: 1.2; }.o1-section-note { color: #73849c; font-size: 11px; }',
            '.o1-table { width: 100%; border-collapse: collapse; table-layout: fixed; }.o1-table th { padding: 9px 11px; color: #5f7390; background: #f2f7fc; border-top: 1px solid #dce7f1; border-bottom: 1px solid #dce7f1; font-size: 11px; font-weight: 750; text-align: left; }.o1-table td { overflow: hidden; padding: 10px 11px; color: #203a60; border-bottom: 1px solid #e6edf5; font-size: 12px; text-overflow: ellipsis; white-space: nowrap; }',
            '.o1-entry { cursor: pointer; }.o1-entry:hover, .o1-entry:focus-visible { background: #f0f8ff; outline: none; }.o1-empty td { padding: 26px 11px; color: #70829a; text-align: center; }',
            '.o1-status { display: inline-flex; padding: 4px 9px; border-radius: 999px; font-size: 11px; font-weight: 750; }.o1-status-open { color: #096bd2; background: #e3f0ff; }.o1-status-processing { color: #966000; background: #fff1d7; }.o1-status-success { color: #087941; background: #e0f7e9; }.o1-status-failed { color: #c92d3d; background: #ffe5e8; }',
            '.o1-validation { color: #0a8a4d; font-size: 11px; font-weight: 750; }.o1-validation.invalid { color: #cf3542; }',
            '.o1-side { display: grid; gap: 14px; align-content: start; }.o1-card { padding-bottom: 12px; }.o1-progress-list, .o1-health-list { display: grid; gap: 13px; padding: 0 15px; }',
            '.o1-progress-row { display: grid; grid-template-columns: 23px minmax(0, 1fr); gap: 9px; }.o1-progress-mark { display: grid; place-items: center; width: 23px; height: 23px; border: 2px solid #b8c7d9; border-radius: 50%; color: #ffffff; background: #ffffff; font-size: 12px; font-weight: 800; }.o1-progress-mark.done { border-color: #14a161; background: #14a161; }.o1-progress-mark.current { border-color: #1682ea; background: #1682ea; }',
            '.o1-progress-copy { min-width: 0; }.o1-progress-label { display: flex; justify-content: space-between; gap: 8px; color: #1b365d; font-size: 12px; font-weight: 750; }.o1-progress-label span:last-child { color: #61758f; font-weight: 600; white-space: nowrap; }.o1-bar { height: 8px; margin-top: 7px; overflow: hidden; background: #e8eef5; border-radius: 999px; }.o1-bar span { display: block; height: 100%; border-radius: inherit; background: #1683e9; }.o1-bar.green span { background: #16a562; }.o1-bar.amber span { background: #dc9a15; }',
            '.o1-health { display: grid; grid-template-columns: 24px minmax(0, 1fr) auto; align-items: center; gap: 9px; padding: 9px 0; border-top: 1px solid #e6edf5; }.o1-health:first-child { border-top: 0; padding-top: 0; }.o1-health-icon { display: grid; place-items: center; width: 23px; height: 23px; border-radius: 50%; color: #0d7f4d; background: #e1f7e9; font-size: 13px; font-weight: 800; }.o1-health-icon.pending { color: #9a6410; background: #fff0d6; }.o1-health-icon.error { color: #d43342; background: #ffe5e8; }.o1-health-label { overflow-wrap: anywhere; color: #233c61; font-size: 12px; font-weight: 700; }.o1-health-value { max-width: 145px; overflow: hidden; padding: 5px 8px; color: #47617f; background: #f3f7fb; border-radius: 5px; font-size: 11px; text-align: right; text-overflow: ellipsis; white-space: nowrap; }',
            '@media (max-width: 1250px) { .o1-hero { align-items: flex-start; flex-direction: column; }.o1-actions { justify-content: flex-start; }.o1-main { grid-template-columns: 1fr; }.o1-side { grid-template-columns: repeat(2, minmax(0, 1fr)); } }',
            '@media (max-width: 850px) { .o1-dashboard { padding: 12px; }.o1-kpis, .o1-side { grid-template-columns: repeat(2, minmax(0, 1fr)); }.o1-kpi { grid-template-columns: 38px minmax(0, 1fr); padding: 10px; }.o1-kpi-icon { width: 38px; height: 38px; font-size: 18px; }.o1-table { min-width: 650px; } }',
            '@media (max-height: 600px) { .o1-dashboard { padding: 6px 8px 8px; }.o1-hero, .o1-alert { display: none; }.o1-kpis { gap: 6px; margin-top: 0; }.o1-kpi { grid-template-columns: 26px minmax(0, 1fr); min-height: 49px; padding: 6px; }.o1-kpi-icon { width: 26px; height: 26px; font-size: 13px; }.o1-kpi-label { font-size: 10px; }.o1-kpi-value { margin-top: 0; font-size: 20px; }.o1-kpi-note { display: none; }.o1-main { gap: 7px; margin-top: 7px; }.o1-section-head { padding: 7px 10px 6px; }.o1-section h2 { font-size: 14px; }.o1-section-note { display: none; }.o1-table th { padding: 6px 8px; font-size: 10px; }.o1-table td { padding: 7px 8px; font-size: 11px; }.o1-side { gap: 7px; }.o1-card { padding-bottom: 7px; }.o1-progress-list, .o1-health-list { gap: 6px; padding: 0 10px; }.o1-progress-row { grid-template-columns: 18px minmax(0, 1fr); gap: 6px; }.o1-progress-mark { width: 18px; height: 18px; font-size: 9px; }.o1-progress-label, .o1-health-label { font-size: 10px; }.o1-bar { height: 5px; margin-top: 3px; }.o1-health { grid-template-columns: 18px minmax(0, 1fr) auto; gap: 5px; padding: 5px 0; }.o1-health-icon { width: 18px; height: 18px; font-size: 10px; }.o1-health-value { max-width: 100px; padding: 3px 5px; font-size: 9px; } }',
            '@media (max-height: 600px) { .o1-main { grid-template-columns: minmax(0, 1.45fr) minmax(0, 1fr); }.o1-side { grid-template-columns: repeat(2, minmax(0, 1fr)); align-content: start; }.o1-health { grid-template-columns: 18px minmax(0, 1fr); }.o1-health-value { grid-column: 2; max-width: none; padding: 0; background: transparent; text-align: left; }.o1-progress-label span:last-child { display: none; } }'
        ].join('\n');
        document.head.appendChild(styles);
    }

    function o1Node(tag, className, value) {
        const result = document.createElement(tag);
        if (className) result.className = className;
        if (value !== undefined && value !== null) result.textContent = value;
        return result;
    }

    function o1Quantity(value) {
        return Number(value) || 0;
    }

    function o1Button(label, icon, action, primary, disabled, hint) {
        const result = o1Node('button', primary ? 'o1-button o1-button-primary' : 'o1-button');
        result.type = 'button';
        result.appendChild(o1Node('span', 'o1-button-icon', icon));
        result.appendChild(o1Node('span', '', label));
        if (disabled) {
            result.disabled = true;
            result.classList.add('is-disabled');
            result.title = hint || '';
        } else {
            result.addEventListener('click', function () { invoke(action); });
        }
        return result;
    }

    function o1Kpi(kind, icon, label, value, note) {
        const result = o1Node('article', 'o1-kpi o1-' + kind);
        result.appendChild(o1Node('div', 'o1-kpi-icon', icon));
        const copy = o1Node('div', 'o1-kpi-copy');
        copy.appendChild(o1Node('div', 'o1-kpi-label', label));
        copy.appendChild(o1Node('div', 'o1-kpi-value', String(value)));
        copy.appendChild(o1Node('div', 'o1-kpi-note', note));
        result.appendChild(copy);
        return result;
    }

    function o1StatusClass(value) {
        const status = String(value || '').toLowerCase();
        if (status === 'failed') return 'o1-status-failed';
        if (status === 'processing') return 'o1-status-processing';
        if (status === 'success') return 'o1-status-success';
        return 'o1-status-open';
    }

    function o1RenderQueue(container, entries) {
        const table = o1Node('table', 'o1-table');
        const thead = o1Node('thead');
        const headerRow = o1Node('tr');
        ['Entry', 'Invoice No.', 'Customer', 'Location', 'Status', 'Validation', 'Received'].forEach(function (heading) {
            headerRow.appendChild(o1Node('th', '', heading));
        });
        thead.appendChild(headerRow);
        table.appendChild(thead);

        const tbody = o1Node('tbody');
        if (!entries || entries.length === 0) {
            const row = o1Node('tr', 'o1-empty');
            const cell = o1Node('td', '', 'No staging entries yet. Configure i6 or use the temporary JSON test upload in Setup.');
            cell.colSpan = 7;
            row.appendChild(cell);
            tbody.appendChild(row);
        } else {
            entries.forEach(function (entry) {
                const row = o1Node('tr', 'o1-entry');
                row.tabIndex = 0;
                row.addEventListener('click', function () { invoke('OpenEntry', [entry.entryNo]); });
                row.addEventListener('keydown', function (event) {
                    if (event.key === 'Enter' || event.key === ' ') {
                        event.preventDefault();
                        invoke('OpenEntry', [entry.entryNo]);
                    }
                });
                [entry.entryNo, entry.invoiceId, entry.customerNo, entry.locationCode].forEach(function (value) {
                    row.appendChild(o1Node('td', '', value || '—'));
                });
                const status = o1Node('td');
                status.appendChild(o1Node('span', 'o1-status ' + o1StatusClass(entry.status), entry.status || 'Open'));
                row.appendChild(status);
                const invalid = String(entry.status || '').toLowerCase() === 'failed';
                row.appendChild(o1Node('td', invalid ? 'o1-validation invalid' : 'o1-validation', invalid ? '● Error' : '● Ready'));
                row.appendChild(o1Node('td', '', entry.receivedAt || '—'));
                tbody.appendChild(row);
            });
        }
        table.appendChild(tbody);
        container.appendChild(table);
    }

    function o1ProgressRow(label, value, total, kind) {
        const result = o1Node('div', 'o1-progress-row');
        const isComplete = total > 0 && value >= total;
        const isCurrent = value > 0 && !isComplete;
        result.appendChild(o1Node('span', 'o1-progress-mark ' + (isComplete ? 'done' : isCurrent ? 'current' : ''), isComplete ? '✓' : isCurrent ? '•' : ''));
        const copy = o1Node('div', 'o1-progress-copy');
        const title = o1Node('div', 'o1-progress-label');
        title.appendChild(o1Node('span', '', label));
        title.appendChild(o1Node('span', '', String(value) + ' / ' + String(total)));
        copy.appendChild(title);
        const bar = o1Node('div', 'o1-bar ' + kind);
        const fill = o1Node('span');
        fill.style.width = String(total > 0 ? Math.min(100, Math.round((value / total) * 100)) : 0) + '%';
        bar.appendChild(fill);
        copy.appendChild(bar);
        result.appendChild(copy);
        return result;
    }

    function o1HealthRow(icon, iconClass, label, value) {
        const result = o1Node('div', 'o1-health');
        result.appendChild(o1Node('span', 'o1-health-icon ' + iconClass, icon));
        result.appendChild(o1Node('span', 'o1-health-label', label));
        result.appendChild(o1Node('span', 'o1-health-value', value));
        return result;
    }

    window.RenderDashboardOptionOne = function (dashboardJson) {
        installOptionOneStyles();
        let model;
        try {
            model = JSON.parse(dashboardJson);
        } catch (error) {
            model = {};
        }

        const ready = o1Quantity(model.ready);
        const processing = o1Quantity(model.processing);
        const failed = o1Quantity(model.failed);
        const success = o1Quantity(model.success);
        const total = o1Quantity(model.total);
        const errorLogs = o1Quantity(model.errorLogCount);
        const inboundEnabled = model.inboundEnabled === true;

        document.body.replaceChildren();
        const dashboard = o1Node('main', 'o1-dashboard');
        dashboard.setAttribute('aria-label', 'UFC Sales Invoice Staging dashboard');

        const hero = o1Node('header', 'o1-hero');
        const titles = o1Node('div');
        titles.appendChild(o1Node('h1', '', 'Sales Invoice Staging'));
        titles.appendChild(o1Node('p', '', 'UFC integration workspace — i6 pull to Business Central'));
        hero.appendChild(titles);
        const actions = o1Node('div', 'o1-actions');
        actions.appendChild(o1Button('Process Ready', '▷', 'ProcessReady'));
        actions.appendChild(o1Button('Open Staging', '▤', 'OpenStaging'));
        actions.appendChild(o1Button('Error Log', '!', 'ReviewErrors'));
        actions.appendChild(o1Button('Refresh', '↻', 'RefreshDashboard'));
        hero.appendChild(actions);
        dashboard.appendChild(hero);

        const alert = o1Node('div', inboundEnabled ? 'o1-alert' : 'o1-alert pending');
        alert.appendChild(o1Node('span', 'o1-alert-mark', inboundEnabled ? '✓' : '!'));
        alert.appendChild(o1Node('span', '', inboundEnabled
            ? 'i6 inbound service is enabled. Mandatory values are validated before data enters staging.'
            : 'i6 inbound service is disabled. Enable it in Integration Setup before i6 sends the EOD payload.'));
        dashboard.appendChild(alert);

        const kpis = o1Node('section', 'o1-kpis');
        kpis.appendChild(o1Kpi('ready', '▣', 'Ready to Process', ready, 'Open staging records'));
        kpis.appendChild(o1Kpi('progress', '↻', 'In Progress', processing, 'Invoice creation underway'));
        kpis.appendChild(o1Kpi('errors', '!', 'Error Log', errorLogs, 'All logged integration issues'));
        kpis.appendChild(o1Kpi('created', '✓', 'Created', success, 'Invoices created in BC'));
        dashboard.appendChild(kpis);

        const main = o1Node('section', 'o1-main');
        const queue = o1Node('section', 'o1-section');
        const queueHead = o1Node('div', 'o1-section-head');
        queueHead.appendChild(o1Node('h2', '', 'Staging Queue'));
        queueHead.appendChild(o1Node('span', 'o1-section-note', 'Select an entry to view header, lines, and errors'));
        queue.appendChild(queueHead);
        o1RenderQueue(queue, model.entries);
        main.appendChild(queue);

        const side = o1Node('aside', 'o1-side');
        const progress = o1Node('section', 'o1-section o1-card');
        const progressHead = o1Node('div', 'o1-section-head');
        progressHead.appendChild(o1Node('h2', '', 'Processing Progress'));
        progress.appendChild(progressHead);
        const progressList = o1Node('div', 'o1-progress-list');
        progressList.appendChild(o1ProgressRow('Received', total, total, 'green'));
        progressList.appendChild(o1ProgressRow('Ready', ready, total, ''));
        progressList.appendChild(o1ProgressRow('Created', success, total, 'amber'));
        progress.appendChild(progressList);
        side.appendChild(progress);

        const health = o1Node('section', 'o1-section o1-card');
        const healthHead = o1Node('div', 'o1-section-head');
        healthHead.appendChild(o1Node('h2', '', 'Integration Health'));
        health.appendChild(healthHead);
        const healthList = o1Node('div', 'o1-health-list');
        healthList.appendChild(o1HealthRow(inboundEnabled ? '✓' : '!', inboundEnabled ? '' : 'pending', 'Inbound service', inboundEnabled ? 'Enabled' : 'Disabled'));
        healthList.appendChild(o1HealthRow('↻', '', 'Last i6 receipt/upload', model.lastActivity || 'Not available'));
        healthList.appendChild(o1HealthRow(errorLogs > 0 ? '!' : '✓', errorLogs > 0 ? 'error' : '', 'Error log', String(errorLogs) + ' logged'));
        healthList.appendChild(o1HealthRow(failed > 0 ? '!' : '✓', failed > 0 ? 'error' : '', 'Failed staging', String(failed) + ' records'));
        health.appendChild(healthList);
        side.appendChild(health);
        main.appendChild(side);
        dashboard.appendChild(main);

        document.body.appendChild(dashboard);
    };

    function installHubStyles() {
        if (document.getElementById('ufc-integration-hub-styles')) return;

        const styles = document.createElement('style');
        styles.id = 'ufc-integration-hub-styles';
        styles.textContent = `
html, body { width: 100%; max-width: 100%; min-width: 0; overflow-x: hidden; }
* { box-sizing: border-box; }
body { margin: 0; color: #122d53; background: #f5f8fc; font-family: "Segoe UI", Arial, sans-serif; }
button { font: inherit; }
.ufc-hub { width: 100%; max-width: 100%; min-height: 100%; padding: 24px; overflow: hidden; background: linear-gradient(135deg, #f7fbff 0%, #ffffff 58%, #f3f9ff 100%); }
.ufc-hub-header { display: flex; justify-content: space-between; gap: 18px; align-items: flex-start; margin-bottom: 20px; }
.ufc-hub h1, .ufc-hub h2, .ufc-hub p { margin: 0; }
.ufc-hub h1 { color: #102a50; font-size: 30px; line-height: 1.15; letter-spacing: -.6px; }
.ufc-hub-subtitle { margin-top: 7px !important; color: #617590; font-size: 14px; }
.ufc-hub-badge { display: inline-flex; padding: 6px 12px; border-radius: 999px; color: #1264cc; background: #e6f1ff; font-size: 12px; font-weight: 750; white-space: nowrap; }
.ufc-hub-cards { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 16px; width: 100%; }
.ufc-hub-card { display: flex; flex-direction: column; min-width: 0; min-height: 235px; padding: 22px; background: #fff; border: 1px solid #d7e2f0; border-radius: 11px; box-shadow: 0 3px 10px rgba(23,54,98,.05); }
.ufc-hub-sales { border-top: 4px solid #147ce5; }.ufc-hub-setup { border-top: 4px solid #7668d8; }
.ufc-hub-eyebrow { color: #617590; font-size: 11px; font-weight: 800; letter-spacing: .8px; }
.ufc-hub h2 { margin-top: 10px; color: #112e55; font-size: 20px; line-height: 1.2; }
.ufc-hub-description { min-height: 57px; margin-top: 10px !important; color: #536a87; font-size: 14px; line-height: 1.45; }
.ufc-hub-metrics { display: flex; gap: 8px; margin-top: 17px; }
.ufc-hub-metric { display: grid; gap: 2px; min-width: 86px; padding: 8px 10px; background: #f4f8fc; border-radius: 6px; }
.ufc-hub-metric strong { color: #173b6d; font-size: 18px; }.ufc-hub-metric span { color: #6b7f99; font-size: 11px; }
.ufc-hub-action { display: inline-flex; align-items: center; justify-content: center; width: 100%; min-height: 39px; margin-top: auto; border: 1px solid #167fe8; border-radius: 7px; color: #fff; background: linear-gradient(180deg, #1685ef, #086fd6); cursor: pointer; font-size: 14px; font-weight: 700; }
.ufc-hub-setup .ufc-hub-action { border-color: #6255c4; background: linear-gradient(180deg, #8375e2, #6255c4); }
.ufc-hub-action:hover, .ufc-hub-action:focus-visible { filter: brightness(.95); outline: 2px solid transparent; }
@media (max-width: 850px) { .ufc-hub { padding: 16px; }.ufc-hub-header { align-items: flex-start; flex-direction: column; }.ufc-hub-cards { grid-template-columns: 1fr; }.ufc-hub-card { min-height: 205px; } }
`;
        document.head.appendChild(styles);
    }

    function hubNode(tag, className, text) {
        const result = document.createElement(tag);
        if (className) result.className = className;
        if (text !== undefined) result.textContent = text;
        return result;
    }

    function hubMetric(label, value) {
        const result = hubNode('div', 'ufc-hub-metric');
        result.appendChild(hubNode('strong', '', String(value || 0)));
        result.appendChild(hubNode('span', '', label));
        return result;
    }

    function hubCard(kind, eyebrow, title, description, buttonText, action, metrics) {
        const result = hubNode('article', 'ufc-hub-card ufc-hub-' + kind);
        result.appendChild(hubNode('div', 'ufc-hub-eyebrow', eyebrow));
        result.appendChild(hubNode('h2', '', title));
        result.appendChild(hubNode('p', 'ufc-hub-description', description));
        if (metrics) {
            const metricArea = hubNode('div', 'ufc-hub-metrics');
            metrics.forEach(function (item) { metricArea.appendChild(hubMetric(item.label, item.value)); });
            result.appendChild(metricArea);
        }
        const button = hubNode('button', 'ufc-hub-action', 'Open ' + buttonText + '  →');
        button.type = 'button';
        button.addEventListener('click', function () { invoke(action); });
        result.appendChild(button);
        return result;
    }

    window.RenderHub = function (hubJson) {
        installHubStyles();
        let model;
        try {
            model = JSON.parse(hubJson);
        } catch (error) {
            model = { salesReady: 0, salesFailed: 0, salesProcessing: 0 };
        }

        document.body.replaceChildren();
        const hub = hubNode('main', 'ufc-hub');
        const header = hubNode('header', 'ufc-hub-header');
        const titles = hubNode('div');
        titles.appendChild(hubNode('h1', '', 'UFC Integration Dashboard'));
        titles.appendChild(hubNode('p', 'ufc-hub-subtitle', 'One workspace for sales, purchase integration, and configuration.'));
        header.appendChild(titles);
        header.appendChild(hubNode('span', 'ufc-hub-badge', 'i6 → Business Central'));
        hub.appendChild(header);

        const cards = hubNode('section', 'ufc-hub-cards');
        cards.appendChild(hubCard('sales', 'SALES', 'Sales Integration', 'Receive i6 sales invoices, review staging records, and create invoices in Business Central.', 'Sales', 'OpenSales', [
            { label: 'Ready', value: model.salesReady },
            { label: 'Needs review', value: model.salesFailed },
            { label: 'Processing', value: model.salesProcessing }
        ]));
        cards.appendChild(hubCard('purchase', 'PURCHASE', 'Purchase Integration', 'Receive i6 purchase orders, review staging records, and create purchase orders in Business Central.', 'Purchase', 'OpenPurchase'));
        cards.appendChild(hubCard('setup', 'COMMON SETUP', 'Integration Setup', 'Maintain inbound i6 service status, mapping, and integration configuration.', 'Setup', 'OpenSetup'));
        hub.appendChild(cards);
        document.body.appendChild(hub);
    };

    invoke('AddInReady');
}());
