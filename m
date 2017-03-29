Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753973AbdC2Lzu (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 29 Mar 2017 07:55:50 -0400
Date: Wed, 29 Mar 2017 07:55:49 -0400 (EDT)
From: Ben England <bengland@redhat.com>
Message-ID: <90086366.8069670.1490788549015.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAKwzdDqvezUQyAvXzh72DW0awAQx5Ct7UwB9ocxuFOWi6Qj-Lg@mail.gmail.com>
References: <CAKwzdDqvezUQyAvXzh72DW0awAQx5Ct7UwB9ocxuFOWi6Qj-Lg@mail.gmail.com>
Subject: Re: Input help for fiologparser.py script in fio/tools/
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>
Cc: fio@vger.kernel.org

Abhishek, fiologparser.py is intended for use with latency, bandwidth and IOPS logs, not the JSON output from fio on stdout.

# ./fiologparser.py -h

if you want something to parse the standard fio json output, you could try this:

https://github.com/bengland2/cbt/blob/master2/tools/fio-parse-json.py

----- Original Message -----
> From: "abhishek koundal" <akoundal@gmail.com>
> To: fio@vger.kernel.org
> Sent: Wednesday, March 29, 2017 12:15:35 AM
> Subject: Input help for fiologparser.py script in fio/tools/
> 
> Hi,
> Can anyone please help in the usage on the fiologparser.py file?
