Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:58469 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbbBPQfM (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 16 Feb 2015 11:35:12 -0500
Received: by mail-qg0-f41.google.com with SMTP id i50so24083008qgf.0
        for <fio@vger.kernel.org>; Mon, 16 Feb 2015 08:35:11 -0800 (PST)
MIME-Version: 1.0
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Mon, 16 Feb 2015 10:34:31 -0600
Message-ID: <CAB-428kQh_D2T4tT7AoP3Gmt=Q4=Z32h7PLwM2fugDwuDFNr=A@mail.gmail.com>
Subject: [Suggestion] Header for --minimal output
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

the --minimal output is very hard to track and decode by script
developers. It would be nice if we can add append a header within the
output file. Then the output file would be self explanatory in
spreadsheet. In this case, for example I would know the column that my
script should track is located in column 72nd. Otherwise, my
understanding is that the only way to discover output is refering to
man page and count/decode columns all by hand.

I wish if my hand had 72 fingers for this case study :-)

--
Alireza
