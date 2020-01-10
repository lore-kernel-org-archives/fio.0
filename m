Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34028 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730345AbgAJA5C (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Jan 2020 19:57:02 -0500
Received: by mail-lf1-f65.google.com with SMTP id l18so190581lfc.1
        for <fio@vger.kernel.org>; Thu, 09 Jan 2020 16:57:01 -0800 (PST)
MIME-Version: 1.0
References: <CA+zhgFSVYMYkDeGEc1Tn3yEy24PgmFRiKABcCQkuEByMuLsnsQ@mail.gmail.com>
 <CALjAwxg+OKr3co5K++St1B=EdztytsDbhWUhNe6Bjz0Vg2uVQw@mail.gmail.com>
 <CA+zhgFRV0LcX+jZOGgjkfc+5v0iwk=C+hVEoP9e1hnTQEMa2vQ@mail.gmail.com> <TU4PR8401MB092733E68E23F041756044D9AB380@TU4PR8401MB0927.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <TU4PR8401MB092733E68E23F041756044D9AB380@TU4PR8401MB0927.NAMPRD84.PROD.OUTLOOK.COM>
From: smitha sunder <sundersmitha@gmail.com>
Date: Thu, 9 Jan 2020 16:56:49 -0800
Message-ID: <CA+zhgFTY4AgJ9EBUk_z7EfN3wxwE8c5Ccx+A4u4aFmFGvdOfdQ@mail.gmail.com>
Subject: Re: 4KiB + 64 B formatted drive : Invalid or incomplete multibyte or
 wide character: write offset=4096, buflen=4096
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio <fio@vger.kernel.org>

On Thu, Jan 9, 2020 at 4:45 PM Elliott, Robert (Servers)
<elliott@hpe.com> wrote:
>
> That errno is EILSEQ, which the linux block layer generates for a few
> reasons related to the T10 protection information (using the internal
> return value of BLK_STS_PROTECTION).
>
> Look at your kernel log (dmesg command) for these two possible reasons:
>     pr_err("%s: ref tag error at location %llu (rcvd %u)\n",
>     pr_err("%s: guard tag error at sector %llu (rcvd %04x, want %04x)\n",
>
>

I don't see a REF TAG error: I did format the drive with pi=1 option :
# nvme format /dev/nvme1 --namespace-id=1 --lbaf=4 --pi=1 --ms=0 -f

kern  :info  : [Thu Jan  9 09:28:44 2020] nvme nvme0: rescanning namespaces.
kern  :info  : [Thu Jan  9 09:28:44 2020] nvme nvme1: rescanning namespaces.
kern  :info  : [Thu Jan  9 16:53:15 2020] nvme nvme0: rescanning namespaces.
kern  :info  : [Thu Jan  9 16:53:15 2020] nvme nvme1: rescanning namespaces.
kern  :info  : [Thu Jan  9 16:53:24 2020] nvme nvme0: rescanning namespaces.
kern  :info  : [Thu Jan  9 16:53:24 2020] nvme nvme1: rescanning namespaces.
kern  :warn  : [Thu Jan  9 16:53:37 2020] print_req_error: 4 callbacks
suppressed
kern  :err   : [Thu Jan  9 16:53:37 2020] blk_update_request:
protection error, dev nvme0n1, sector 8 op 0x0:(READ) flags 0x10000
phys_seg 1 prio class 0
kern  :err   : [Thu Jan  9 16:53:37 2020] Buffer I/O error on dev
nvme0n1, logical block 1, async page read
kern  :err   : [Thu Jan  9 16:53:37 2020] Dev nvme0n1: unable to read
RDB block 8
kern  :info  : [Thu Jan  9 16:53:37 2020]  nvme0n1: unable to read
partition table
kern  :err   : [Thu Jan  9 16:53:37 2020] blk_update_request:
protection error, dev nvme0n1, sector 3750748672 op 0x0:(READ) flags
0x90700 phys_seg 1 prio class 0
kern  :err   : [Thu Jan  9 16:53:37 2020] blk_update_request:
protection error, dev nvme0n1, sector 3750748672 op 0x0:(READ) flags
0x10000 phys_seg 1 prio class 0
kern  :err   : [Thu Jan  9 16:53:37 2020] Buffer I/O error on dev
nvme0n1, logical block 468843584, async page read
kern  :err   : [Thu Jan  9 16:53:37 2020] blk_update_request:
protection error, dev nvme0n1, sector 2048 op 0x1:(WRITE) flags
0x18800 phys_seg 1 prio class 0
kern  :err   : [Thu Jan  9 16:53:37 2020] blk_update_request:
protection error, dev nvme0n1, sector 8 op 0x0:(READ) flags 0x10000
phys_seg 1 prio class 0
kern  :err   : [Thu Jan  9 16:53:37 2020] Buffer I/O error on dev
nvme0n1, logical block 1, async page read
kern  :err   : [Thu Jan  9 16:53:37 2020] Dev nvme0n1: unable to read
RDB block 8
kern  :info  : [Thu Jan  9 16:53:37 2020]  nvme0n1: unable to read
partition table
kern  :err   : [Thu Jan  9 16:53:37 2020] blk_update_request:
protection error, dev nvme0n1, sector 3750748672 op 0x0:(READ) flags
0x90700 phys_seg 1 prio class 0
kern  :err   : [Thu Jan  9 16:53:37 2020] blk_update_request:
protection error, dev nvme0n1, sector 3750748672 op 0x0:(READ) flags
0x10000 phys_seg 1 prio class 0
kern  :err   : [Thu Jan  9 16:53:37 2020] Buffer I/O error on dev
nvme0n1, logical block 468843584, async page read

Also if its REF tag error, shouldn't I have seen the same issue with
4K+ 8B meta data? fio works fine with 4K+8 format.

Thanks
smitha

