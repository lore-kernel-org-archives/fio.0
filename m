Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f42.google.com ([209.85.128.42]:34473 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728695AbgAMIEq (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Jan 2020 03:04:46 -0500
Received: by mail-wm1-f42.google.com with SMTP id w5so9157660wmi.1
        for <fio@vger.kernel.org>; Mon, 13 Jan 2020 00:04:45 -0800 (PST)
MIME-Version: 1.0
References: <CA+zhgFSVYMYkDeGEc1Tn3yEy24PgmFRiKABcCQkuEByMuLsnsQ@mail.gmail.com>
 <CALjAwxg+OKr3co5K++St1B=EdztytsDbhWUhNe6Bjz0Vg2uVQw@mail.gmail.com>
 <CA+zhgFRV0LcX+jZOGgjkfc+5v0iwk=C+hVEoP9e1hnTQEMa2vQ@mail.gmail.com>
 <TU4PR8401MB092733E68E23F041756044D9AB380@TU4PR8401MB0927.NAMPRD84.PROD.OUTLOOK.COM>
 <CA+zhgFTY4AgJ9EBUk_z7EfN3wxwE8c5Ccx+A4u4aFmFGvdOfdQ@mail.gmail.com> <TU4PR8401MB09274B35275964C4D924BAF5AB380@TU4PR8401MB0927.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <TU4PR8401MB09274B35275964C4D924BAF5AB380@TU4PR8401MB0927.NAMPRD84.PROD.OUTLOOK.COM>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 13 Jan 2020 08:04:18 +0000
Message-ID: <CALjAwxioWYxdHY+myk=tSkncuQn8qLdVUTGSSDzprSSsHJJKYA@mail.gmail.com>
Subject: Re: 4KiB + 64 B formatted drive : Invalid or incomplete multibyte or
 wide character: write offset=4096, buflen=4096
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc: smitha sunder <sundersmitha@gmail.com>, fio <fio@vger.kernel.org>

On Fri, 10 Jan 2020 at 06:35, Elliott, Robert (Servers) <elliott@hpe.com> wrote:
>
> What are all those reads to LBA 3750748672? Something is looking
> for partition tables?
>
> You're using direct=1 so the page cache shouldn't be doing
> prefetching.

If you scribble over the start of a disk that can trigger udev rules
to rescan partitions and maybe that is checking for a backup GPT...

-- 
Sitsofe | http://sucs.org/~sits/

