Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:60197 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaATVr6 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 20 Jan 2014 16:47:58 -0500
Received: by mail-oa0-f43.google.com with SMTP id h16so7730767oag.16
        for <fio@vger.kernel.org>; Mon, 20 Jan 2014 13:47:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <748581DD-9A26-41D7-A537-58F6D6741B33@gmail.com>
References: <748581DD-9A26-41D7-A537-58F6D6741B33@gmail.com>
Date: Mon, 20 Jan 2014 13:47:58 -0800
Message-ID: <CAJBj3vfjD=vz7XNmL-X1XNpJiUjp63kSFcQPM+kvjuKEWHsMnQ@mail.gmail.com>
Subject: Re: Strange aggregate BW
From: John Williams <jwilliams4200@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: grant <626542@gmail.com>
Cc: fio@vger.kernel.org

On Mon, Jan 20, 2014 at 1:23 PM, grant <626542@gmail.com> wrote:

> I=EF=BF=BDve got a HWRAID with 10 NL-SAS HDDs.

If it is HW RAID6 with 10 total drives, then the aggregrate write
throughput to the HDDs is about 25% ( 10 / 8 - 1 ) higher than the
write throughput that fio measures as going into the HW RAID device.

So you'd be looking at about 266MB/s per drive. Which seems unlikely.
I wonder if your HW RAID has a large cache. Did you let the fio job
run for the full 10 minutes? Because I would expect the cache to fill
well before 10 minutes, unless the cache is huge.
