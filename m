Return-Path: <fio-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:50819 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaCQUfC (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 17 Mar 2014 16:35:02 -0400
Date: Mon, 17 Mar 2014 20:34:58 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: correct file size to use
Message-ID: <20140317203457.GA11577@sucs.org>
References: <53243539.5010405@adon.li>
 <CACVXFVNbNpwH44DHfN+BU2a7KvF=Ah7As3+UwKHB8eGOX6b7ug@mail.gmail.com>
 <CAF+0mvmJqfvzdDrj8qWxmfgAh7jM9=f20v2pMTpFU-75vuTFRw@mail.gmail.com>
 <CACVXFVN9O7HF6LJ=k-mygGHLWcpsQ3chWkkukdp+rFqnunJ60w@mail.gmail.com>
 <5327577B.8050703@adon.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5327577B.8050703@adon.li>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: jvogt <jvogt@adon.li>
Cc: Ming Lei <tom.leiming@gmail.com>, Matthew Eaton <m.eaton82@gmail.com>, fio@vger.kernel.org, Carl Zwanzig <cpz@coraid.com>

On Mon, Mar 17, 2014 at 09:13:47PM +0100, jvogt wrote:
> 
> I just wanted to make some tests before taking it all in production.
> Thank you all for your answers!

If you want raw upper maximum numbers try using direct=1 ioengine=libaio
with an appropriate iodepth against the openiscsi block device. Bear in
mind things like iodepth and whether coalescing can take place can make
a huge difference...

-- 
Sitsofe | http://sucs.org/~sits/
