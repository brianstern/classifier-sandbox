from django.conf.urls import patterns, include, url
from django.contrib import admin
admin.autodiscover()
 
from rest_framework.urlpatterns import format_suffix_patterns
 
urlpatterns = []
 
urlpatterns += patterns('',
    url(r'^admin/', include(admin.site.urls)),
)
 
urlpatterns += format_suffix_patterns(
    patterns('classifier_sandbox.views',
        url(r'^$', 'home'),
        url(r'^browse/$', 'api_root'),
    )
)