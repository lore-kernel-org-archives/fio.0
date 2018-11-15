Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it1-f173.google.com ([209.85.166.173]:40218 "EHLO
        mail-it1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbeKORDR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Nov 2018 12:03:17 -0500
Received: by mail-it1-f173.google.com with SMTP id e11so27747974itl.5
        for <fio@vger.kernel.org>; Wed, 14 Nov 2018 22:56:43 -0800 (PST)
MIME-Version: 1.0
From: Mousumi Mullick <mousumi.mullick@gmail.com>
Date: Wed, 14 Nov 2018 22:56:31 -0800
Message-ID: <CAHt2jbtMQ3Hcxk0o4+-AauE6iOcZOewCBpfv0_VdNu4ZiX4kKA@mail.gmail.com>
Subject: Save verify_state continuously
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I am planning to run fio on a dozens of virtual machines across
multiple physical hosts and at some point will power off a physical
host. As fio workload is running I will be triggering random VM
migrations across a set of physical hosts. Since powering off a
physical host will abruptly power off all VMs running on that host,
none of the fio processes in them will have a verify_state file saved.

Given this test, I was wondering if there is a way for fio to
continuously save verify_state to a file so that I can use it
unconditionally on a subsequent power on to verify the data written so
far?


-- 
Thanks,
Mousumi Mullick

