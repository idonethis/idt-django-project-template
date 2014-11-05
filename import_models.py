from django.apps import apps

print 'Importing models:'
for app_config in apps.get_app_configs():
    for model in app_config.get_models():
        print '    %s' % model.__name__
        locals()[model.__name__] = model
