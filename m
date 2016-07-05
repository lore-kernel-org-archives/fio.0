Return-Path: <axboe@kernel.dk>
Subject: Re: gfio - Error Gdk-ERROR **: g_thread_init() must be called before
 gdk_threads_init()
References: <D5FAFAB3-16BE-4BC9-85EB-EAAC44C45DD8@netapp.com>
 <577C1687.2050609@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <577C17A1.2090007@kernel.dk>
Date: Tue, 5 Jul 2016 14:25:05 -0600
MIME-Version: 1.0
In-Reply-To: <577C1687.2050609@kernel.dk>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 07/05/2016 02:20 PM, Jens Axboe wrote:
> On 06/27/2016 12:04 PM, neto from Brazil wrote:
>> Hi All,
>>
>> This is neto from Brazil
>>
>> How are you?
>>
>> Compiling gfio is OK but when I have tried to execute, I’ve got this
>> error:
>>
>> Gdk-ERROR **: g_thread_init() must be called before gdk_threads_init()
>>
>> Could someone please help me?
>
> What version of gtk are you using? gfio will call g_thread_init(), if
> it's less than version 2.2.24.

Looks like I was mistaken, it's needed up until glib 2.31 - I've updated 
the check, git pull and it should (hopefully) work for you.

-- 
Jens Axboe


