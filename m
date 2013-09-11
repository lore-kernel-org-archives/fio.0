Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:63566 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab3IKOSl (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 11 Sep 2013 10:18:41 -0400
Received: by mail-lb0-f175.google.com with SMTP id y6so7406335lbh.6
        for <fio@vger.kernel.org>; Wed, 11 Sep 2013 07:18:39 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 11 Sep 2013 10:18:38 -0400
Message-ID: <CABFR9T2g8oBJNNLjUXqvy4k8rdCuq=N_Hrjzd5up6jC0QYN-+g@mail.gmail.com>
Subject: genfio - feature request(s) and "bug" report
From: Roger Sibert <roger_sibert@xyratex.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: FIO <fio@vger.kernel.org>

From an earlier thread the logging feature I was using was adjusted to
better support/handle genfio so I was looking at that and had a small
set of feature requests for it along with a minor bug fix for the next
time someones updated the file.

Feature Request:  Add a flag to enable/disable gathering of latency
logs and add the ability to gather latency logs.

Feature Request:  Add a flag or modify the code to not use "," in the
filename.  Perhaps use "_" instead?

The bug really is just a misspelling, anoter vs another

Thanks,
Roger
