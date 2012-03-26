Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40434 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958Ab2CZSuo (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 26 Mar 2012 14:50:44 -0400
Message-ID: <4F70BA80.9030803@kernel.dk>
Date: Mon, 26 Mar 2012 20:50:40 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: distrubuted iops measuring
References: <4F6F9581.9010207@cesnet.cz>
In-Reply-To: <4F6F9581.9010207@cesnet.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jiri Horky <jiri.horky@cesnet.cz>
Cc: fio@vger.kernel.org

On 2012-03-26 00:00, Jiri Horky wrote:
> Hi,
> 
> I would like to measure IOPS on a distributed file system from several 
> hosts in parallel.
> I am a bit lost in what options I should use. I would like to have each 
> host in a cluster accessing its own file to not stress metadata and/or 
> locking infrastructure. I thought that on all clients, I should run just:
> 
> fio --server
> 
> And from an admin node something like
> 
> fio --client server1 job.desc.1 --client server2 job.desc.2 --client 
> server3 job.desc.3...., where job.desc.X is specific to the client 
> (different filename).
> 
> But it seems like each host executes each job file, which is not what I 
> would like...
> I bet there is a way how to accomplish this. Could you please point me 
> to the right direction?

That is/was indeed the intended idea. It's just a parsing issue that
causes it to support just one job file across a bunch of hosts, it's not
a fio limitation. So it should be relatively easy to fix. Your above
incantation ends up being identical to doing:

$ fio --client server1 --client server2 --client server3 job1 job2 job3

I can fix this when I get the time, or you can dive into it yourself if
you want. It's in init.c:parse_cmd_line().

-- 
Jens Axboe

