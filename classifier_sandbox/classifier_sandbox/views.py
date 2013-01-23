from rest_framework import generics
from rest_framework import permissions
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse

from django.views.decorators.csrf import ensure_csrf_cookie
from django.shortcuts import render

from gamera.core import init_gamera
from gamera import gamera_xml

import StringIO
import base64
 
@api_view(('GET',))
def api_root(request, format=None):
    return Response({
            'projects': reverse('project-list', request=request, format=format)
        })

@ensure_csrf_cookie
def home(request):
    init_gamera()
    encoded_glyphs = []
    gamera_glyphs = gamera_xml.glyphs_from_xml('/Volumes/Shared/LU-OMR/Liber_Usualis_NO_ST/Processed_Pages/1234/classifier_glyphs_1234_654.xml')
    for gamera_glyph in gamera_glyphs:
        glyph = gamera_glyph.to_rgb().to_pil()
        buf = StringIO.StringIO()
        glyph.save(buf, format='PNG')
        png = buf.getvalue()
        encoded_png = base64.b64encode(png)
        encoded_glyphs.append(encoded_png)
    for glyph in encoded_glyphs:
        print glyph
        print ""
    return render(request, 'index.html', {
        'encoded_glyphs': encoded_glyphs
    })