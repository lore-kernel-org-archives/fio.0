Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33232 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751655AbaCFVUX (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 6 Mar 2014 16:20:23 -0500
Message-ID: <5318E68A.1000904@fb.com>
Date: Thu, 6 Mar 2014 14:20:10 -0700
From: Jens Axboe <axboe@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] Two small ./configure fixes
References: <1394127719-3105-1-git-send-email-stefanha@redhat.com> <20140306181450.GA23848@sucs.org>
In-Reply-To: <20140306181450.GA23848@sucs.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: fio@vger.kernel.org, bcran@fusionio.com

On 03/06/2014 11:14 AM, Sitsofe Wheeler wrote:
> On Thu, Mar 06, 2014 at 06:41:57PM +0100, Stefan Hajnoczi wrote:
>> My hopes of cross-compiling fio for Windows were dashed when I realized
>> pthreads is needed (I guess only Cygwin supports it, not mingw).
>
> I think mingw supports pthreads using winpthreads (see
> https://urldefense.proofpoint.com/v1/url?u=http://thread.gmane.org/gmane.comp.storage.fio/97/focus%3D149&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=3JMVyziIyZtZ5cv9eWNLwQ%3D%3D%0A&m=UhTi1rWRqSE0ZT%2B5li5HCwkSWuK8mUG1CqLBrQTtHU0%3D%0A&s=28594f27ce732489c3620148921f10705aa70e811eeaf337622bc397dae3f21d ). Does fio
> even compile with pure cygwin gcc (rather than mingw)? I think I had a
> brief try and it complained about conflicting headers...

Probably want to pull Bruce into this thread.

-- 
Jens Axboe


