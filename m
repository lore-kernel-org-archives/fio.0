Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:55909 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaBKEpW (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 10 Feb 2014 23:45:22 -0500
Received: by mail-qa0-f52.google.com with SMTP id j15so10850760qaq.25
        for <fio@vger.kernel.org>; Mon, 10 Feb 2014 20:45:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029548A6481@G9W0745.americas.hpqcorp.net>
References: <94D0CD8314A33A4D9D801C0FE68B4029548A6481@G9W0745.americas.hpqcorp.net>
Date: Mon, 10 Feb 2014 20:45:19 -0800
Message-ID: <CAJBj3vd4d5cL49WyTki=3XBQwNZG0orryBwvzdPL6D6MAPP-EA@mail.gmail.com>
Subject: Re: [PATCH] Fix documentation of SI vs. binary prefixes
From: John Williams <jwilliams4200@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Mon, Feb 10, 2014 at 4:40 PM, Elliott, Robert (Server Storage)
<Elliott@hp.com> wrote:
> fio specifies SI and binary units backwards, presumably for compatibility with old scripts.

I think the proper way to fix something like that is to follow the
standards and do it the right way.

Then have an option --use-old-units or something like that to reverse
it for compatibility with old scripts.
