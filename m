Return-Path: <fio-owner@vger.kernel.org>
Received: from sm02.isp.telecom.li ([217.173.238.131]:51405 "EHLO
	sm02.isp.telecom.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaCQUOP (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 17 Mar 2014 16:14:15 -0400
Message-ID: <5327577B.8050703@adon.li>
Date: Mon, 17 Mar 2014 21:13:47 +0100
From: jvogt <jvogt@adon.li>
MIME-Version: 1.0
Subject: Re: correct file size to use
References: <53243539.5010405@adon.li>	<CACVXFVNbNpwH44DHfN+BU2a7KvF=Ah7As3+UwKHB8eGOX6b7ug@mail.gmail.com>	<CAF+0mvmJqfvzdDrj8qWxmfgAh7jM9=f20v2pMTpFU-75vuTFRw@mail.gmail.com> <CACVXFVN9O7HF6LJ=k-mygGHLWcpsQ3chWkkukdp+rFqnunJ60w@mail.gmail.com>
In-Reply-To: <CACVXFVN9O7HF6LJ=k-mygGHLWcpsQ3chWkkukdp+rFqnunJ60w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, Matthew Eaton <m.eaton82@gmail.com>, fio@vger.kernel.org, Carl Zwanzig <cpz@coraid.com>


Am 17.03.2014 03:55, schrieb Ming Lei:
> On Mon, Mar 17, 2014 at 7:16 AM, Matthew Eaton
>> Tested on my system and saw no difference in performance.  Direct io
>> will bypass the page cache so the only thing that comes to mind would
> Looks I miss the '--direct=1' parameter, :-(
>
>> be an on-device cache, though, I would think the difference in
>> performance would be more dramatic if that were the case.
> Another possible cause might be related with storage for the
> big file. If the file is stored in lot of fragments of the disk, accessing
> the whole file might become slower than just the first 10M, but not
> sure if there is so big difference(30%).

> Direct io
will bypass the page cache so the only thing that comes to mind would
be an on-device cache, though, I would think the difference in
performance would be more dramatic if that were the case.

This could be possible - I'm not so sure how to check that...
My setup is the following:
RHEL6.5 as virtual machine via VMWare - the storage is a Dell Equallogic 
Storage connected via ISCSI to the host. These tests are not made via NFS.
I just wanted to make some tests before taking it all in production.
Thank you all for your answers!
Josef
