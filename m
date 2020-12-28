Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.phas.ubc.ca ([142.103.236.13]:53916 "EHLO mail.phas.ubc.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbgL1EJb (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 27 Dec 2020 23:09:31 -0500
Content-Type: text/plain; charset="utf-8"
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: Standard test parameters for NAS workloads?
From: Davor Cubranic <davor@phas.ubc.ca>
In-Reply-To: <CACnDUNr9-4udmB11Lfr7q5a7xUBONJKfBSd7FODTxi3YCXwE8A@mail.gmail.com>
Date: Sun, 27 Dec 2020 20:08:49 -0800
Content-Transfer-Encoding: 8bit
Message-Id: <5A1A02B5-5D4D-4244-9474-91A47C8D229D@phas.ubc.ca>
References: <CACnDUNrKDbee11b0xhSR1sYrkmetO3x0TpuesxrS-GHVe+kfoA@mail.gmail.com>
 <43E1A684-43B5-4E97-AE78-19E151F6B498@phas.ubc.ca>
 <CACnDUNr9-4udmB11Lfr7q5a7xUBONJKfBSd7FODTxi3YCXwE8A@mail.gmail.com>
List-Id: fio@vger.kernel.org
To: rickyp999@gmail.com
Cc: fio@vger.kernel.org

I don’t know, and would myself be interested to hear what you learned!

Davor

> On Dec 22, 2020, at 7:28 PM, rickyp999@gmail.com wrote:
> 
> One more question if that's ok, the articles did not really mention
> how they handled networking. Looking at the commands and the test
> scaffolding, it seems like these tests ran directly against the disks
> locally. I'm curious if there's anything one should do differently
> when testing against them on networked filesystems such as SMB or NFS,
> like whether one should use different settings compared to testing
> against local disks with regards to. For example, I don't know how
> buffered I/O works on networked filesystems and whether to turn it on
> or off in the tests.


