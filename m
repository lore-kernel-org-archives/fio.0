Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60927 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965255Ab3DPWNa (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 16 Apr 2013 18:13:30 -0400
Received: by mail-wi0-f174.google.com with SMTP id m6so2059511wiv.1
        for <fio@vger.kernel.org>; Tue, 16 Apr 2013 15:13:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <A7A1D348E34E024BBC74480FB93A2EAB026DFC@DAGN05A-E6.exg6.exghost.com>
References: <A7A1D348E34E024BBC74480FB93A2EAB026DFC@DAGN05A-E6.exg6.exghost.com>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Tue, 16 Apr 2013 18:12:58 -0400
Message-ID: <CAGpXXZ+ok5Rf7rRhQ+TOPPvpDH1L0ke13oeHcLyfYHAvPdPkyg@mail.gmail.com>
Subject: Re: Fio ignoring runtime after an error?
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Carl Zwanzig <cpz@coraid.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Tue, Apr 16, 2013 at 1:54 PM, Carl Zwanzig <cpz@coraid.com> wrote:
> Hopefully, I'll get the clue to inject an error into the disk system and run this down, but that'll take time I don't really have.

hdparm --make-bad-sector   can be used to inject an error in a ata drive.

See http://lwn.net/Articles/269721/ for details

Greg
