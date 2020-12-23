Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgLWD3a (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 22 Dec 2020 22:29:30 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36C4C0613D3
        for <fio@vger.kernel.org>; Tue, 22 Dec 2020 19:28:49 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id n127so3413644ooa.13
        for <fio@vger.kernel.org>; Tue, 22 Dec 2020 19:28:49 -0800 (PST)
MIME-Version: 1.0
References: <CACnDUNrKDbee11b0xhSR1sYrkmetO3x0TpuesxrS-GHVe+kfoA@mail.gmail.com>
 <43E1A684-43B5-4E97-AE78-19E151F6B498@phas.ubc.ca>
In-Reply-To: <43E1A684-43B5-4E97-AE78-19E151F6B498@phas.ubc.ca>
From: "rickyp999@gmail.com" <rickyp999@gmail.com>
Date: Tue, 22 Dec 2020 19:28:37 -0800
Message-ID: <CACnDUNr9-4udmB11Lfr7q5a7xUBONJKfBSd7FODTxi3YCXwE8A@mail.gmail.com>
Subject: Re: Standard test parameters for NAS workloads?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
List-Id: fio@vger.kernel.org
To: Davor Cubranic <davor@phas.ubc.ca>
Cc: fio@vger.kernel.org

These are great articles. Thank you so much and I'll incorporate some
of these tests into my configurations.

One more question if that's ok, the articles did not really mention
how they handled networking. Looking at the commands and the test
scaffolding, it seems like these tests ran directly against the disks
locally. I'm curious if there's anything one should do differently
when testing against them on networked filesystems such as SMB or NFS,
like whether one should use different settings compared to testing
against local disks with regards to. For example, I don't know how
buffered I/O works on networked filesystems and whether to turn it on
or off in the tests.

Thank you,

On Mon, Dec 21, 2020 at 5:21 PM Davor Cubranic <davor@phas.ubc.ca> wrote:
>
> These are the fio settings used by StorageReview.com in their benchmarks:=
 https://www.storagereview.com/fio-flexible-i-o-tester-synthetic-benchmark
>
> Ars Technica=E2=80=99s series on RAID vs. ZFS (https://arstechnica.com/ga=
dgets/2020/05/zfs-versus-raid-eight-ironwolf-disks-two-filesystems-one-winn=
er) used this set of tests: https://github.com/jimsalterjrs/fio-test-scaffo=
lding
>
>
>
> On Dec 21, 2020, at 2:49 PM, rickyp999@gmail.com wrote:
>
> Hi,
>
> I'm curious whether there are some standard or at least common test
> parameters for benchmarking NAS workloads.
>
> If NAS is too specific, even a general one for HDD/SSD would be
> greatly appreciated.  My motivation is to use a common set of
> benchmarks to compare how options like RAID levels, network
> speed/protocol (through a NFS/SMB mount), and SSD cache affect
> performance.
>
> Thank you,
>
>

