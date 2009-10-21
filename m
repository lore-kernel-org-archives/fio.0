Return-Path: <radha@google.com>
MIME-Version: 1.0
Date: Tue, 20 Oct 2009 18:27:27 -0700
Message-ID: <66dfd3fe0910201827y60bf72c5rcf3375e08cd36e6@mail.gmail.com>
Subject: verify_pattern size restriction
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <jens.axboe@oracle.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi,
Is there a reason why there is a 32 bit size restriction on the
verify_pattern parameter.
I have the fio code changes to handle verify_pattern of size <= 512
bytes, Iam still testing it. But wanted to know if there was any
special reason for the restriction before I sent the patch out.
thanks
-Radha

