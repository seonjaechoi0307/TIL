from django.shortcuts import render
from django.http import HttpResponse

from django.core.mail import send_mail
from django.conf import settings

# Create your views here.

def index(request):
    if request.method == "POST":
        message = request.POST['message']
        email = request.POST['email']
        name = request.POST['name']
        send_mail(
            name, # 이메일 제목
            message, # 이메일 메시지
            'settings.EMAIL_HOST_USER', # 서버의 이메일 주소
            [email] # 사용자의 이메일 주소
        )
    return render(request, 'main/index.html')
