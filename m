Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37259 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829AbaCFVcU (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 6 Mar 2014 16:32:20 -0500
Message-ID: <5318E962.5040207@fb.com>
Date: Thu, 6 Mar 2014 14:32:18 -0700
From: Jens Axboe <axboe@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] Two small ./configure fixes
References: <1394127719-3105-1-git-send-email-stefanha@redhat.com>
In-Reply-To: <1394127719-3105-1-git-send-email-stefanha@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Stefan Hajnoczi <stefanha@redhat.com>, fio@vger.kernel.org

On 03/06/2014 10:41 AM, Stefan Hajnoczi wrote:
> My hopes of cross-compiling fio for Windows were dashed when I realized
> pthreads is needed (I guess only Cygwin supports it, not mingw).
>
> On the plus side, here are two small fixes for ./configure.
>
> Stefan Hajnoczi (2):
>    Honor ./configure --cc= option
>    Detect Windows operating system in ./configure

Thanks, applied both.

-- 
Jens Axboe

