Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk1-f171.google.com ([209.85.221.171]:42146 "EHLO
        mail-vk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbeKOVie (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Nov 2018 16:38:34 -0500
Received: by mail-vk1-f171.google.com with SMTP id y14so4376727vky.9
        for <fio@vger.kernel.org>; Thu, 15 Nov 2018 03:31:06 -0800 (PST)
MIME-Version: 1.0
References: <CAHt2jbtMQ3Hcxk0o4+-AauE6iOcZOewCBpfv0_VdNu4ZiX4kKA@mail.gmail.com>
In-Reply-To: <CAHt2jbtMQ3Hcxk0o4+-AauE6iOcZOewCBpfv0_VdNu4ZiX4kKA@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 15 Nov 2018 11:30:39 +0000
Message-ID: <CALjAwxicij8N=d6qCQoDz33tbjw4epM_MZtN1LoKQ7B5+X8nTA@mail.gmail.com>
Subject: Re: Save verify_state continuously
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: mousumi.mullick@gmail.com
Cc: fio <fio@vger.kernel.org>

Hi,

On Thu, 15 Nov 2018 at 06:57, Mousumi Mullick <mousumi.mullick@gmail.com> wrote:
>
> I am planning to run fio on a dozens of virtual machines across
> multiple physical hosts and at some point will power off a physical
> host. As fio workload is running I will be triggering random VM
> migrations across a set of physical hosts. Since powering off a
> physical host will abruptly power off all VMs running on that host,
> none of the fio processes in them will have a verify_state file saved.
>
> Given this test, I was wondering if there is a way for fio to
> continuously save verify_state to a file so that I can use it
> unconditionally on a subsequent power on to verify the data written so
> far?

Why not create a trigger file (see
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-trigger-file
, https://fio.readthedocs.io/en/latest/fio_doc.html#verification-and-triggers
) to let fio know it needs to do a state save (it will also exit
itself)? You may even be able to arrange for fio to send a command
that powers the host off if you're using the client/server model with
the appropriate trigger type. Further, don't you need to know fio has
finished doing the state save correctly (note the that the trigger
file will be deleted when fio is done with it)? If you power off a VM
halfway through fio saving its state you risk generating/getting an
incomplete/corrupt state file...

-- 
Sitsofe | http://sucs.org/~sits/

