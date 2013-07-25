Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:53244 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176Ab3GYUDD (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Jul 2013 16:03:03 -0400
Received: by mail-qc0-f170.google.com with SMTP id s1so1177077qcw.15
        for <fio@vger.kernel.org>; Thu, 25 Jul 2013 13:03:01 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 25 Jul 2013 14:03:01 -0600
Message-ID: <CAOtMX2jEtNYwUct2VN6E2TBoDXXm7oJSXwzJiqKfXGzNvG3QLQ@mail.gmail.com>
Subject: Definition of IO depth distribution in the terse output
From: asomers@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The man page section for the terse output format describes the IO
depth distribution fields as "<=1, 2, 4, 8, 16, 32, >=64".  Should the
last entry be ">32" instead?  Similarly, in the section for IO latency
distribution, should the final value be ">2000" instead of ">=2000"?

-Alan
