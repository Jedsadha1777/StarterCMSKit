import re
from marshmallow import Schema, fields, validate, validates, ValidationError, EXCLUDE, post_load


# ── Shared validators ──

ALPHANUMERIC_RE = re.compile(r'^[A-Za-z0-9\-_]+$')


def alphanumeric(value):
    if not ALPHANUMERIC_RE.match(value):
        raise ValidationError('Must contain only English letters, numbers, hyphens or underscores')


password_length = validate.Length(min=6, error='Password must be at least 6 characters')


# ── Admin ──

class AdminCreateSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    name = fields.String(required=True, validate=validate.Length(min=1))
    email = fields.String(required=True, validate=validate.Length(min=1))
    password = fields.String(required=True, validate=password_length)
    role = fields.String(required=True, validate=validate.OneOf(['admin', 'editor']))


class AdminUpdateSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    name = fields.String(validate=validate.Length(min=1))
    email = fields.String(validate=validate.Length(min=1))
    password = fields.String(validate=password_length)
    role = fields.String(validate=validate.OneOf(['admin', 'editor']))


class AdminResponseSchema(Schema):
    id = fields.Method('get_id')
    name = fields.String()
    email = fields.String()
    role = fields.Method('get_role')
    company_id = fields.Method('get_company_id')
    company_name = fields.Method('get_company_name')
    is_super_admin = fields.Boolean()
    created_at = fields.DateTime(format='iso')
    updated_at = fields.DateTime(format='iso')
    permissions = fields.Method('get_permissions_list')
    limits = fields.Method('get_limits_dict')

    def get_id(self, obj):
        return obj.public_id

    def get_role(self, obj):
        return obj.role.value if obj.role else None

    def get_company_id(self, obj):
        return obj.company.public_id if obj.company else None

    def get_company_name(self, obj):
        return obj.company.name if obj.company else None

    def get_permissions_list(self, obj):
        return obj.get_permissions()

    def get_limits_dict(self, obj):
        return obj.get_limits()


# ── User ──

class UserCreateSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    name = fields.String(required=True, validate=validate.Length(min=1))
    email = fields.String(required=True, validate=validate.Length(min=1))
    password = fields.String(required=True, validate=password_length)


class UserUpdateSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    name = fields.String(validate=validate.Length(min=1))
    email = fields.String(validate=validate.Length(min=1))
    password = fields.String(validate=password_length)


class UserResponseSchema(Schema):
    id = fields.Method('get_id')
    name = fields.String()
    email = fields.String()
    company_name = fields.Method('get_company_name')
    created_at = fields.DateTime(format='iso')
    updated_at = fields.DateTime(format='iso')

    def get_id(self, obj):
        return obj.public_id

    def get_company_name(self, obj):
        return obj.company.name if obj.company else None


# ── Article ──

class ArticleCreateSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    title = fields.String(required=True, validate=validate.Length(min=1))
    content = fields.String(required=True, validate=validate.Length(min=1))
    status = fields.String(load_default='draft', validate=validate.OneOf(['draft', 'published']))
    publish_date = fields.DateTime(format='iso', load_default=None)


class ArticleUpdateSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    title = fields.String(validate=validate.Length(min=1))
    content = fields.String(validate=validate.Length(min=1))
    status = fields.String(validate=validate.OneOf(['draft', 'published']))
    publish_date = fields.DateTime(format='iso', allow_none=True)


class ArticleResponseSchema(Schema):
    id = fields.Method('get_id')
    title = fields.String()
    content = fields.String()
    author_id = fields.Method('get_author_id')
    author_email = fields.Method('get_author_email')
    status = fields.String()
    publish_date = fields.DateTime(format='iso')
    version = fields.Integer()
    is_deleted = fields.Boolean()
    created_at = fields.DateTime(format='iso')
    updated_at = fields.DateTime(format='iso')

    def get_id(self, obj):
        return obj.public_id

    def get_author_id(self, obj):
        return obj.admin_author.public_id if obj.admin_author else None

    def get_author_email(self, obj):
        return obj.admin_author.email if obj.admin_author else None


# ── Customer ──

class CustomerCreateSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    customer_id = fields.String(required=True, validate=[validate.Length(min=1), alphanumeric])
    name = fields.String(required=True, validate=validate.Length(min=1))
    address = fields.String(load_default='')


class CustomerUpdateSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    customer_id = fields.String(validate=[validate.Length(min=1), alphanumeric])
    name = fields.String(validate=validate.Length(min=1))
    address = fields.String(allow_none=True)


class CustomerResponseSchema(Schema):
    id = fields.Method('get_id')
    customer_id = fields.String()
    name = fields.String()
    address = fields.String()
    created_by = fields.Method('get_created_by')
    created_by_name = fields.Method('get_created_by_name')
    created_at = fields.DateTime(format='iso')
    updated_at = fields.DateTime(format='iso')

    def get_id(self, obj):
        return obj.public_id

    def get_created_by(self, obj):
        return obj.creator.public_id if obj.creator else None

    def get_created_by_name(self, obj):
        return obj.creator.name if obj.creator else None


# ── InspectionItem ──

class InspectionItemCreateSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    item_code = fields.String(required=True, validate=[validate.Length(min=1), alphanumeric])
    item_name = fields.String(required=True, validate=validate.Length(min=1))
    spec = fields.String(load_default='')


class InspectionItemUpdateSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    item_code = fields.String(validate=[validate.Length(min=1), alphanumeric])
    item_name = fields.String(validate=validate.Length(min=1))
    spec = fields.String(allow_none=True)


class InspectionItemResponseSchema(Schema):
    id = fields.Method('get_id')
    item_code = fields.String()
    item_name = fields.String()
    spec = fields.String()
    created_by = fields.Method('get_created_by')
    created_by_name = fields.Method('get_created_by_name')
    created_at = fields.DateTime(format='iso')
    updated_at = fields.DateTime(format='iso')

    def get_id(self, obj):
        return obj.public_id

    def get_created_by(self, obj):
        return obj.creator.public_id if obj.creator else None

    def get_created_by_name(self, obj):
        return obj.creator.name if obj.creator else None


# ── MachineModel ──

class MachineModelCreateSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    model_code = fields.String(required=True, validate=[validate.Length(min=1), alphanumeric])
    model_name = fields.String(required=True, validate=validate.Length(min=1))
    inspection_item_ids = fields.List(fields.String(), load_default=[])


class MachineModelUpdateSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    model_code = fields.String(validate=[validate.Length(min=1), alphanumeric])
    model_name = fields.String(validate=validate.Length(min=1))
    inspection_item_ids = fields.List(fields.String(), load_default=None)


class MachineModelResponseSchema(Schema):
    id = fields.Method('get_id')
    model_code = fields.String()
    model_name = fields.String()
    inspection_items = fields.Method('get_inspection_items')
    created_by = fields.Method('get_created_by')
    created_by_name = fields.Method('get_created_by_name')
    created_at = fields.DateTime(format='iso')
    updated_at = fields.DateTime(format='iso')

    def get_id(self, obj):
        return obj.public_id

    def get_inspection_items(self, obj):
        return [item.to_dict() for item in obj.inspection_items]

    def get_created_by(self, obj):
        return obj.creator.public_id if obj.creator else None

    def get_created_by_name(self, obj):
        return obj.creator.name if obj.creator else None


# ── Company ──

class CompanyCreateSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    name = fields.String(required=True, validate=validate.Length(min=1))
    package_id = fields.Integer(load_default=None, allow_none=True)


class CompanyUpdateSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    name = fields.String(validate=validate.Length(min=1))
    package_id = fields.Integer(allow_none=True)
    report_cc_email = fields.String(allow_none=True)


class CompanyResponseSchema(Schema):
    id = fields.Method('get_id')
    name = fields.String()
    parent_id = fields.Integer()
    package_id = fields.Integer()
    is_root = fields.Boolean()
    report_cc_email = fields.String()
    created_at = fields.DateTime(format='iso')
    updated_at = fields.DateTime(format='iso')

    def get_id(self, obj):
        return obj.public_id


# ── ImportHistory ──

class ImportHistoryResponseSchema(Schema):
    id = fields.Method('get_id')
    resource_type = fields.String()
    original_filename = fields.String()
    imported_by = fields.Method('get_imported_by')
    imported_by_name = fields.Method('get_imported_by_name')
    created_at = fields.DateTime(format='iso')

    def get_id(self, obj):
        return obj.public_id

    def get_imported_by(self, obj):
        return obj.importer.public_id if obj.importer else None

    def get_imported_by_name(self, obj):
        return obj.importer.name if obj.importer else None


# ── Package ──

class PackageResponseSchema(Schema):
    id = fields.Integer()
    name = fields.String()
    description = fields.String()
    limits = fields.Method('get_limits')
    created_at = fields.DateTime(format='iso')
    updated_at = fields.DateTime(format='iso')

    def get_limits(self, obj):
        return {l.resource: l.max_value for l in obj.limits}


# ── Profile ──

class ProfileUpdateSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    name = fields.String(required=True, validate=validate.Length(min=1))


class ChangePasswordSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    old_password = fields.String(required=True)
    new_password = fields.String(required=True, validate=password_length)


# ── Report ──

class ReportCreateSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    form_data = fields.Dict(required=True)
    recipient_emails = fields.List(fields.Email(), required=True, validate=validate.Length(min=1))
    machine_model_id = fields.String(required=True)
    customer_id = fields.String(load_default=None)
    serial_no = fields.String(load_default=None)
    inspector_name = fields.String(load_default=None)
    inspected_at = fields.DateTime(format='iso', load_default=None)

    @validates('form_data')
    def validate_form_data(self, value, **kwargs):
        if not value:
            raise ValidationError('form_data must not be empty')


class ReportStatusUpdateSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    status = fields.String(required=True, validate=validate.OneOf(['reviewed', 'approved', 'rejected']))


class ReportResponseSchema(Schema):
    id = fields.Method('get_id')
    report_no = fields.String()
    form_data = fields.Dict()
    machine_model_id = fields.Method('get_machine_model_id')
    customer_id = fields.Method('get_customer_id')
    serial_no = fields.String()
    inspector_name = fields.String()
    user_id = fields.Method('get_user_id')
    user_name = fields.Method('get_user_name')
    status = fields.String()
    inspected_at = fields.DateTime(format='iso')
    sent_at = fields.DateTime(format='iso')
    email_recipients = fields.Raw()
    pdf_path = fields.Method('get_has_pdf')
    created_at = fields.DateTime(format='iso')
    updated_at = fields.DateTime(format='iso')

    def get_id(self, obj):
        return obj.public_id

    def get_machine_model_id(self, obj):
        return obj.machine_model.public_id if obj.machine_model else None

    def get_customer_id(self, obj):
        return obj.customer.public_id if obj.customer else None

    def get_user_id(self, obj):
        return obj.user.public_id if obj.user else None

    def get_user_name(self, obj):
        return obj.user.name if obj.user else None

    def get_has_pdf(self, obj):
        return obj.pdf_path if obj.pdf_path else None


# ── Report Settings ──

class ReportSettingsSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    report_cc_email = fields.String(allow_none=True)


# ── Login ──

class LoginSchema(Schema):
    class Meta:
        unknown = EXCLUDE
    email = fields.String(required=True, validate=validate.Length(min=1))
    password = fields.String(required=True, validate=validate.Length(min=1))
