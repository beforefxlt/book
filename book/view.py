from django.http import Http404, HttpResponse, HttpResponseRedirect
from django.shortcuts import render
import datetime
from book.forms import ContactForm
from django.core.mail import send_mail, get_connection


def contact(request):
    if request.method == 'POST':
        form = ContactForm(request.POST)
        if form.is_valid():
            cd = form.cleaned_data
            con= get_connection()
