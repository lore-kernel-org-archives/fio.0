Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:37489 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab3JCTbX (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 3 Oct 2013 15:31:23 -0400
Received: by mail-lb0-f179.google.com with SMTP id x18so2472298lbi.10
        for <fio@vger.kernel.org>; Thu, 03 Oct 2013 12:31:22 -0700 (PDT)
MIME-Version: 1.0
From: "Brian L." <brianclam@gmail.com>
Date: Thu, 3 Oct 2013 12:31:02 -0700
Message-ID: <CAAAK+WW66DdYt2JEG+2K42vWzczn38xtnh5WK-1x97zFbdkyqg@mail.gmail.com>
Subject: precondition ssd drives w/ fio
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

For benchmarking SSD drives, I was told that we should precondition
our drives to get more accurate real world reading.

I was wondering if anyone is using fio itself to precondition ssd
drives or use a different script to populate random data on the
drives?

Thanks in advance.

Brian L.
