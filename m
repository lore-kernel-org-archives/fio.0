Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:49860 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751573AbdJWSrn (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Oct 2017 14:47:43 -0400
Received: by mail-vk0-f51.google.com with SMTP id r82so11771218vke.6
        for <fio@vger.kernel.org>; Mon, 23 Oct 2017 11:47:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGjEAhugzO6y4K2426xcnyFmOvTLH+mw5BU3ofA6DNiw1Rjn2w@mail.gmail.com>
References: <CAGjEAhugzO6y4K2426xcnyFmOvTLH+mw5BU3ofA6DNiw1Rjn2w@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 23 Oct 2017 19:47:11 +0100
Message-ID: <CALjAwxjy9jpfQ=eci9OWJx7PyztYRRRfVrZ30PncsGr=Hu5wWQ@mail.gmail.com>
Subject: Re: FIO workload profile for VMS Server
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: qingwei wei <tchengwee@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 23 October 2017 at 06:59, qingwei wei <tchengwee@gmail.com> wrote:
>
> I am currently looking at simulating IO workload for VMS server. I
> read that usually VMS has recording server and each recording server
> can support up to a number of IP camera. For example, if recording
> server can support up to 150 IP cameras, does it means i will need to
> configure 150 jobs in FIO to simulate that? And what is the typical
> file size for the recorded video stream? Thanks.

Workload modelling is a huge topic in and of itself and there are few
easy answers - every approach has tradeoffs. I'm afraid I have no
insight into the typical file size of IP cameras. I'd imagine it's
highly dependent on the scene, the size of the picture, the FPS, the
CPU you have available, the level of compression you're asking it to
do etc.

One approach is to record your all your workloads being generated
together with blktrace
(https://www.cse.unsw.edu.au/~aaronc/iosched/doc/blktrace.html ) and
then use btreplay
(http://www.cse.unsw.edu.au/~aaronc/iosched/doc/btreplay.html ) or
fio's read_iolog (see
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-read-iolog
).

It's hard to say if 150 jobs is good or not. It could be your system
does some sort of multiplexing so only one stream is actually saved to
disk...

-- 
Sitsofe | http://sucs.org/~sits/
