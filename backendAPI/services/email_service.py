import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
import os
from config import SMTP_SERVER, SMTP_PORT, SMTP_USERNAME, SMTP_PASSWORD, SMTP_SENDER_NAME


def send_report_email(report, user, recipient_emails, pdf_path, cc_email=None):
    if not SMTP_USERNAME or not SMTP_PASSWORD:
        raise RuntimeError('SMTP credentials not configured')

    msg = MIMEMultipart()
    msg['From'] = f'{SMTP_SENDER_NAME} <{SMTP_USERNAME}>'
    msg['To'] = ', '.join(recipient_emails)
    if cc_email:
        msg['Cc'] = cc_email
    msg['Subject'] = f'Service Report - {report.report_no}'

    body = f'Please find the attached service report file for No.: {report.report_no}'
    msg.attach(MIMEText(body, 'plain'))

    if pdf_path:
        if not os.path.exists(pdf_path):
            raise FileNotFoundError(f'PDF not found: {pdf_path}')
        with open(pdf_path, 'rb') as f:
            part = MIMEBase('application', 'pdf')
            part.set_payload(f.read())
            encoders.encode_base64(part)
            part.add_header('Content-Disposition', f'attachment; filename="{os.path.basename(pdf_path)}"')
            msg.attach(part)

    all_recipients = list(recipient_emails)
    if cc_email:
        all_recipients.append(cc_email)

    with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
        server.starttls()
        server.login(SMTP_USERNAME, SMTP_PASSWORD)
        server.sendmail(SMTP_USERNAME, all_recipients, msg.as_string())
