Return-Path: <axboe@kernel.dk>
Subject: Re: gfio - Error Gdk-ERROR **: g_thread_init() must be called before
 gdk_threads_init()
References: <D5FAFAB3-16BE-4BC9-85EB-EAAC44C45DD8@netapp.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <577C1687.2050609@kernel.dk>
Date: Tue, 5 Jul 2016 14:20:23 -0600
MIME-Version: 1.0
In-Reply-To: <D5FAFAB3-16BE-4BC9-85EB-EAAC44C45DD8@netapp.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 06/27/2016 12:04 PM, neto from Brazil wrote:
> Hi All,
>
> This is neto from Brazil
>
> How are you?
>
> Compiling gfio is OK but when I have tried to execute, I’ve got this error:
>
> Gdk-ERROR **: g_thread_init() must be called before gdk_threads_init()
>
> Could someone please help me?

What version of gtk are you using? gfio will call g_thread_init(), if 
it's less than version 2.2.24.

-- 
Jens Axboe


