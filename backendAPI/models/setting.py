from extensions import db


class Setting(db.Model):
    __tablename__ = 'settings'

    key = db.Column(db.String(50), primary_key=True)
    value = db.Column(db.Text, nullable=False, default='')

    DEFAULTS = {
        'site_title': 'Admin Panel',
        'logo': '',
        'favicon': '',
        'posts_per_page': '10',
        'date_format': 'YYYY-MM-DD',
        'primary_color': '#c4193c',
    }

    @staticmethod
    def get(key):
        row = Setting.query.get(key)
        if row:
            return row.value
        return Setting.DEFAULTS.get(key, '')

    @staticmethod
    def get_all():
        rows = Setting.query.all()
        result = dict(Setting.DEFAULTS)
        for row in rows:
            result[row.key] = row.value
        return result

    @staticmethod
    def set(key, value):
        row = Setting.query.get(key)
        if row:
            row.value = value
        else:
            db.session.add(Setting(key=key, value=value))
