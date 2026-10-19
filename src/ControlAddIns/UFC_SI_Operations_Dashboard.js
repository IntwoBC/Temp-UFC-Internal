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
        result.appendChild(node('span', 'pipeline-marker', state === 'done' ? '✓' : state === 'current' ? '•••' : ''));
        const copy = node('div', 'pipeline-copy');
        copy.appendChild(node('strong', '', label));
        copy.appendChild(node('span', '', detail));
        result.appendChild(copy);
        return result;
    }

    function metric(label, value) {
        const result = node('div', 'metric');
        result.appendChild(node('strong', '', String(value || 0)));
        result.appendChild(node('span', '', label));
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
        container.appendChild(table);
    }

    window.RenderDashboard = function (dashboardJson) {
        let model;
        try {
            model = JSON.parse(dashboardJson);
        } catch (error) {
            model = { ready: 0, failed: 0, processing: 0, success: 0, total: 0, entries: [] };
        }

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
        notice.appendChild(node('span', '', 'Mandatory fields are validated before records enter staging'));
        desk.appendChild(notice);

        const pipeline = node('section', 'pipeline');
        pipeline.appendChild(pipelineStep('Receive from i6', 'Payload received', 'done'));
        pipeline.appendChild(pipelineStep('Validate', 'Mandatory checks', 'done'));
        pipeline.appendChild(pipelineStep('Store in Staging', 'Ready for processing', 'current'));
        pipeline.appendChild(pipelineStep('Create Invoice', 'Internal BC process', 'pending'));
        desk.appendChild(pipeline);

        const panels = node('section', 'panels');
        const attention = node('article', 'panel attention');
        const attentionTitle = node('div', 'panel-title');
        attentionTitle.appendChild(node('span', 'symbol error-symbol', '!'));
        attentionTitle.appendChild(node('h2', '', 'Attention Required'));
        attention.appendChild(attentionTitle);
        const errorSummary = node('div', 'summary error-summary');
        errorSummary.appendChild(node('strong', '', String(model.failed || 0)));
        errorSummary.appendChild(node('span', '', 'staging records with validation or processing errors'));
        attention.appendChild(errorSummary);
        attention.appendChild(node('p', 'panel-note', model.failed ? 'Review failed records and correct the reported BC data or configuration.' : 'No validation or processing errors require attention.'));
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
        metrics.appendChild(metric('Errors', model.failed));
        metrics.appendChild(metric('Processing', model.processing));
        ready.appendChild(metrics);
        panels.appendChild(ready);
        desk.appendChild(panels);

        const entriesPanel = node('section', 'entries-panel');
        const entriesHeading = node('div', 'entries-heading');
        entriesHeading.appendChild(node('h2', '', 'Recent Staging Entries'));
        entriesHeading.appendChild(node('span', '', 'Select an entry to view its header, lines, and error details'));
        entriesPanel.appendChild(entriesHeading);
        renderEntries(entriesPanel, model.entries);
        desk.appendChild(entriesPanel);
        document.body.appendChild(desk);
    };

    invoke('AddInReady');
}());
