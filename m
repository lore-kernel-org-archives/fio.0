Return-Path: <fio-owner@vger.kernel.org>
Received: from sm02.isp.telecom.li ([217.173.238.131]:53698 "EHLO
	sm02.isp.telecom.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaCQUlF (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 17 Mar 2014 16:41:05 -0400
Message-ID: <53275DCC.8050506@adon.li>
Date: Mon, 17 Mar 2014 21:40:44 +0100
From: jvogt <jvogt@adon.li>
MIME-Version: 1.0
Subject: Re: correct file size to use
References: <53243539.5010405@adon.li> <CACVXFVNbNpwH44DHfN+BU2a7KvF=Ah7As3+UwKHB8eGOX6b7ug@mail.gmail.com> <CAF+0mvmJqfvzdDrj8qWxmfgAh7jM9=f20v2pMTpFU-75vuTFRw@mail.gmail.com> <CACVXFVN9O7HF6LJ=k-mygGHLWcpsQ3chWkkukdp+rFqnunJ60w@mail.gmail.com> <5327577B.8050703@adon.li> <20140317203457.GA11577@sucs.org>
In-Reply-To: <20140317203457.GA11577@sucs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Matthew Eaton <m.eaton82@gmail.com>, fio@vger.kernel.org, Carl Zwanzig <cpz@coraid.com>


Am 17.03.2014 21:34, schrieb Sitsofe Wheeler:
> On Mon, Mar 17, 2014 at 09:13:47PM +0100, jvogt wrote:
>> I just wanted to make some tests before taking it all in production.
>> Thank you all for your answers!
> If you want raw upper maximum numbers try using direct=1 ioengine=libaio
> with an appropriate iodepth against the openiscsi block device. Bear in
> mind things like iodepth and whether coalescing can take place can make
> a huge difference...
Please explain, what do you mean with appropriate iodepth? What would 
you suggest?
