Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:35785 "EHLO
	mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbcF1F0E (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 28 Jun 2016 01:26:04 -0400
Received: by mail-vk0-f47.google.com with SMTP id j2so7656528vkg.2
        for <fio@vger.kernel.org>; Mon, 27 Jun 2016 22:26:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP8ELLVPLs59wFTix0h4CBoS1ZQ7A5Fj8V_t-V+UUSusENb11A@mail.gmail.com>
References: <CAP8ELLWHUR5_Zia8X03eOotDUW8M-5u3pA_ie=sXD8cvwh1e5g@mail.gmail.com>
 <CAP8ELLVPLs59wFTix0h4CBoS1ZQ7A5Fj8V_t-V+UUSusENb11A@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 28 Jun 2016 06:26:02 +0100
Message-ID: <CALjAwxgQ3EnAJmh3pzLpUyEa5nsLOfD6KLgmn-zgsN21Ohi24w@mail.gmail.com>
Subject: Re: fio bug
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Frank Londono <flonclondono@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 27 June 2016 at 22:20, Frank Londono <flonclondono@gmail.com> wrote:
> Just started using tkperf/fio, and am the system crashes:
>
> Jun 27 12:02:14 qual6 org.debian.apt[1424]: 12:02:14 AptDaemon.Worker
> [INFO]: Finished transaction /org/debian/apt/transaction/
> Jun 27 12:02:44 qual6 kernel: [ 1939.769050] swap_free: Bad swap
> offset entry 8641b9fff80
> Jun 27 12:02:44 qual6 kernel: [ 1939.769059] BUG: Bad page map in
> process fio  pte:10c8373fff0040 pmd:335c5067
> Jun 27 12:02:44 qual6 kernel: [ 1939.769063] addr:00007ff321a00000
> vm_flags:080000fb anon_vma:          (null) mapping:ffff880196cc8e90
> index:3ab2
> Jun 27 12:02:44 qual6 kernel: [ 1939.769073] file:SYSV00000000
> fault:shm_fault mmap:shm_mmap readpage:          (null)
> Jun 27 12:02:44 qual6 kernel: [ 1939.769078] CPU: 0 PID: 3005 Comm:
> fio Not tainted 4.4.0-24-generic #43-Ubuntu
> Jun 27 12:02:44 qual6 kernel: [ 1939.769081] Hardware name: Dell
> Computer Corporation PowerEdge 1800/0P8611, BIOS A07 09/29/2006
> Jun 27 12:02:44 qual6 kernel: [ 1939.769084]  0000000000000286
> 0000000063f6c1a4 ffff880196f97c38 ffffffff813eab23
> Jun 27 12:02:44 qual6 kernel: [ 1939.769090]  00007ff321a00000
> ffff880196eb2578 ffff880196f97c88 ffffffff811bc32f
> Jun 27 12:02:44 qual6 kernel: [ 1939.769095]  ffff880196f97c60
> ffffffff811d33e0 000008641b9fff80 0010c8373fff0040
> Jun 27 12:02:44 qual6 kernel: [ 1939.769099] Call Trace:
> Jun 27 12:02:44 qual6 kernel: [ 1939.769109]  [<ffffffff813eab23>]
> dump_stack+0x63/0x90
> Jun 27 12:02:44 qual6 kernel: [ 1939.769115]  [<ffffffff811bc32f>]
> print_bad_pte+0x1df/0x2a0
> Jun 27 12:02:44 qual6 kernel: [ 1939.769121]  [<ffffffff811d33e0>] ?
> swap_info_get+0xb0/0xd0
> Jun 27 12:02:44 qual6 kernel: [ 1939.769125]  [<ffffffff811bdcb8>]
> unmap_page_range+0x468/0x7a0
> Jun 27 12:02:44 qual6 kernel: [ 1939.769129]  [<ffffffff811be06d>]
> unmap_single_vma+0x7d/0xe0
> Jun 27 12:02:44 qual6 kernel: [ 1939.769133]  [<ffffffff811beb31>]
> unmap_vmas+0x51/0xa0
> Jun 27 12:02:44 qual6 kernel: [ 1939.769136]  [<ffffffff811c45bc>]
> unmap_region+0xac/0x120
> Jun 27 12:02:44 qual6 kernel: [ 1939.769141]  [<ffffffff81223cd0>] ?
> __dentry_kill+0x160/0x1e0
> Jun 27 12:02:44 qual6 kernel: [ 1939.769145]  [<ffffffff811c6aca>]
> do_munmap+0x28a/0x480
> Jun 27 12:02:44 qual6 kernel: [ 1939.769149]  [<ffffffff8132c9d2>]
> SyS_shmdt+0xb2/0x170
> Jun 27 12:02:44 qual6 kernel: [ 1939.769156]  [<ffffffff81825bf2>]
> entry_SYSCALL_64_fastpath+0x16/0x71
> Jun 27 12:02:44 qual6 kernel: [ 1939.769159] Disabling lock debugging
> due to kernel taint
> Jun 27 12:02:44 qual6 kernel: [ 1939.769161] swap_free: Bad swap
> offset entry 1f800000

Assuming your hardware isn't buggy you've tickled a bug in the kernel
rather than a bug in fio so this isn't the right list of your issue.
Since you're running an Ubuntu kernel you need to report it to Ubuntu
(e.g. via https://bugs.launchpad.net/ubuntu/+source/linux/+filebug )
unless you can also reproduce it on the latest mainline kernel from
kernel.org (4.7-rc5 at the time of writing) in which case you would
better off reporting on the Linux Kernel Mailing List / the kernel.org
Bugzilla.

-- 
Sitsofe | http://sucs.org/~sits/
