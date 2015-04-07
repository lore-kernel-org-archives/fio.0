Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:36673 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbbDGRXy (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 7 Apr 2015 13:23:54 -0400
Received: by qgeb100 with SMTP id b100so23914142qge.3
        for <fio@vger.kernel.org>; Tue, 07 Apr 2015 10:23:53 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 7 Apr 2015 13:23:53 -0400
Message-ID: <CAGGT8x4wvSkDni2+T8mViRCQHQiVt9C1AwMTaU8rk4rvNRaK4A@mail.gmail.com>
Subject: A probable minor mistake in HOWTO page
From: Mansour Shafaei Moghaddam <mansoor.shafaei@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I found a minor mistake in the Fio's HOWTO page. According to this
document the "wait" command considers the offset as the number of
milliseconds which it must hold on before submitting the next I/O. A
very simple experiment with a short trace including those "wait"
commands shows that the numbers that you put as offset are interpreted
as the time for submission of next I/O not the amount of wait time
between them. In other words, the value in offset field is the
absolute delay from the beginning of run not the relative delay.

P.S.: The version of fio I have been working on is 2.1.11, but I saw
the same explanation in more recent versions' HOWTO page as well. So,
decided to share it with you.

Mansour
