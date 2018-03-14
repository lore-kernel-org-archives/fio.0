Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43352 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751426AbeCNGqo (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Mar 2018 02:46:44 -0400
Date: Wed, 14 Mar 2018 02:46:44 -0400 (EDT)
From: Erwan Velu <evelu@redhat.com>
Message-ID: <368477604.10754890.1521010004445.JavaMail.zimbra@redhat.com>
In-Reply-To: <8d5a5fe209774d24b9df39cf6a226dbb@mail.gmail.com>
References: <8d5a5fe209774d24b9df39cf6a226dbb@mail.gmail.com>
Subject: Re: Proper way to shut down FIO in Linux
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matt Freel <matt.freel@broadcom.com>
Cc: fio@vger.kernel.org

Hey,

Why do you want to kill fio ? That sounds weird to me.

If you need to run your benchmark on constant time then use time_based & runtime instructions.

----- Mail original -----
De: "Matt Freel" <matt.freel@broadcom.com>
À: fio@vger.kernel.org
Envoyé: Mardi 13 Mars 2018 19:56:10
Objet: Proper way to shut down FIO in Linux

I'm using FIO to run IOs to a number of block devices.  I'm looking for
the proper way to shut down all the threads that are spawned.

I'm doing the following:

/usr/bin/pkill --signal INT fio

Most of the time this works fine, but I do have cases where some of the
FIO processes remain open.  Eventually I get a 300s timeout and then
they're killed.

A couple questions:

1.	When these threads have to be ungracefully killed, do the results
still get counted in the output file?
a.	I'm using JSON output file
2.	Is there a better way I should be killing all the threads?
--
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
