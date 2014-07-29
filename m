Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:36489 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaG2F2U (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 29 Jul 2014 01:28:20 -0400
Received: from /spool/local
	by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Tue, 29 Jul 2014 06:28:19 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 460161B08040
	for <fio@vger.kernel.org>; Tue, 29 Jul 2014 06:29:03 +0100 (BST)
Received: from d06av07.portsmouth.uk.ibm.com (d06av07.portsmouth.uk.ibm.com [9.149.37.248])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s6T5SHJx33685676
	for <fio@vger.kernel.org>; Tue, 29 Jul 2014 05:28:17 GMT
Received: from d06av07.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av07.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s6T5SGwf018239
	for <fio@vger.kernel.org>; Tue, 29 Jul 2014 01:28:17 -0400
Message-ID: <53D730F0.3030908@linux.vnet.ibm.com>
Date: Tue, 29 Jul 2014 07:28:16 +0200
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: Pull an external [global] section into an .fio file?
References: <CANvN+e=7M4A=g9ro1dmOJdC2NBj4+iEUaCYrwGfmGY+bpUsnNA@mail.gmail.com> <CAM8G_BJ3HNtZB6wjqFUiXSo4Zwzzqy7i34+2xkpvCENuzE0EHg@mail.gmail.com> <A7A1D348E34E024BBC74480FB93A2EAB108B4DB1@DAGN05C-E6.exg6.exghost.com>
In-Reply-To: <A7A1D348E34E024BBC74480FB93A2EAB108B4DB1@DAGN05C-E6.exg6.exghost.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Carl Zwanzig <cpz@coraid.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 28/07/14 20:35, Carl Zwanzig wrote:
> Hi,
>
> For the most part, I've stopped using job files and use a script to write/execute a fio command line. I do end up with hideously-long command lines (>1100 chars), but can stash all the parameters in the script or included file and easily iterate over certain ones.
>

We went a similar way, but not that far to push all into the commandline.
The reason for that is that I liked the job file format, it was easy to 
grasp for everyone - and eventually I have jobfiles I can pass along if 
I identify a bug.

So what I ended up was having a few basic profiles (for totally 
different fio job behaviour) and filling a lot of things via environment 
variables that are set by a wrapper script.

In my opinion that gives you the flexibility to iterate like Carl 
suggested in his solution while keeping the majority of the jobfile 
semantic.

For example our global section often is only something like this:
[global]
bs=${FIO_BS}
[...]

And you can even add non-predefined options with a trick like this:
${FIO_FREEPARM1}
[...]

Just make the variable contain the full specification like "numjobs=4" 
and it will work. In case you don't use those I usually set 
description=n/a to all of them to avoid bugs due to unset variables.

I hope one of the suggestions helps you,
Christian

