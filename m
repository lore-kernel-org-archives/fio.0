Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:36764 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbbE1AFR (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 27 May 2015 20:05:17 -0400
Received: by oihb142 with SMTP id b142so20242107oih.3
        for <fio@vger.kernel.org>; Wed, 27 May 2015 17:05:17 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 May 2015 17:05:17 -0700
Message-ID: <CALSnuyzG9MaUW0dh2-19WvPAFDDupu9QC-zK0Pz+8vZzs+fvJA@mail.gmail.com>
Subject: fio offset cycling.
From: Adrin Fernandes <adrin.fernandes@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
I'm using a statically compiled fio-2.2.8 binary to run some
benchmarks with the fill_device option set to true with an offset of
rw=write:4m on Linux and Windows.

My file is a block device.

Looking through the write_iolog, I see the offset keeps cycling. Once
the offset is beyond the disk size, it resets to zero and starts all
over again.

I'm not sure if this is a bug or not?

Is this expected behavior?

Any help would be appreciated.

Regards,
Adrin.
