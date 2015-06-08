Return-Path: <fio-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:54566 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbbFHUxh (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 8 Jun 2015 16:53:37 -0400
Date: Mon, 8 Jun 2015 16:53:34 -0400 (EDT)
From: Ben England <bengland@redhat.com>
Message-ID: <282041200.10368508.1433796814574.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAB-428koubWB28tS_AAcSPdpAJRQCCYNEFgKx3r3m6wjM=Z7hA@mail.gmail.com>
References: <CAB-428kC-cZ0wQczthe=-RwGO_sn9F7e3BdyWa2f4a3ZkgAu0g@mail.gmail.com> <CALjAwxgjQhgnR+XmtJKtvrMpkwJLzY1v1W-TEiVaz3ZOZEgWzA@mail.gmail.com> <CAB-428koubWB28tS_AAcSPdpAJRQCCYNEFgKx3r3m6wjM=Z7hA@mail.gmail.com>
Subject: Re: [Suggestion] Aggregated Client/Server Stats Reporting
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alireza Haghdoost <haghdoost@gmail.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio@vger.kernel.org

I've recently done tests without group_reporting option and with --client=hosts.list (that's what you mean by "servers" right?), and fio DID compute an aggregate bandwidth for multiple servers in "All clients" jobname.  What happened to that when group_reporting option is on?

----- Original Message -----
> From: "Alireza Haghdoost" <haghdoost@gmail.com>
> To: "Sitsofe Wheeler" <sitsofe@gmail.com>
> Cc: fio@vger.kernel.org
> Sent: Saturday, June 6, 2015 9:29:30 AM
> Subject: Re: [Suggestion] Aggregated Client/Server Stats Reporting
> 
> On Fri, Jun 5, 2015 at 12:51 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> > I'm guessing trying to use group_reporting
> > (https://github.com/axboe/fio/blob/fio-2.2.8/HOWTO#L1379 ) didn't
> > help?
> >
> 
> group_reporting does aggregate the performance metrics for multiple
> jobs in one server. However, it does not aggregate numbers for
> multiple servers.
