Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8EC18B47F
	for <fio@vger.kernel.org>; Mon,  9 Sep 2024 21:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725915805; cv=none; b=YT5LNTsI2vpBfJEiTVLlp/C/ETq7VI0ctYCT5DAx6YPiDDK7a244GWdGarmpCj57RJPZPV6Wi0lQA38V9nWmZ0EjvWh6wfCnOjnbj4lmasGoh65YhGUhP5WQSuabVGJI9wt3hmAQrhXMX63eaufoXVR1RkaWMOwfww2mtY+bf6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725915805; c=relaxed/simple;
	bh=psvSxQ/zjlNbzRUq0qm/NzWRCClD/Etksn2rJmLfs5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q7Ybi11ThN098Y3XO+DkmD7XIjVAzGRM1QrSao0ybIoNhIwJRHhheoD7JQbGQLwDp2JR3M6RIQhjkUN/PLOo0rrPbO9ziITMXI/tGSisiD2QKgLPOFolFtOSCnqlHs91tS9Xi8OAjR23SmtlMU5SfnxuEwxO4jj1S3muJSgZTgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CquNGn41; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CquNGn41"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Us1r5jtRPSbOvke5eABAY7MzjKs5Dzq9YfLkHYSCkis=; b=CquNGn41ZZTMZ+OHooI6IXnZn8
	GdIbYN8j04LTCH73fLmKLyWs5ywVfAO62MP/+JJiR3l9kBAQk4lXW7xrsPXzGpG7+ko3AP4ORlh/x
	HhZ6A4N/8cTr4v9nJA/hFIolvFtlr136+Asq4omiNq/mJUoultNbwWW8QiXibaGIMOJjHQYG291V0
	DXKw0/ji0YKBZUPnmJWeMWQEG/kQ/+js5ndy+6X23gqdBrqf1tJE5EN2qfOkn9n9ecDuhK7o07zlv
	G7t0Y49sANf8lz6aJqRs6FaImVtAzCbs46kMiWBxn09uaFLEb1PSC6vOm0YS+u9KHeCoLtKK5jbro
	1gwn/+Hw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1snlXf-00000003JJj-1CNv;
	Mon, 09 Sep 2024 21:03:23 +0000
Date: Mon, 9 Sep 2024 14:03:23 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: John Garry <john.g.garry@oracle.com>,
	Vincent Fu <vincent.fu@samsung.com>, fio@vger.kernel.org,
	martin.petersen@oracle.com, djwong@kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Dan Helmick <dan.helmick@samsung.com>
Subject: Re: [PATCH 0/7] fio: atomic write support
Message-ID: <Zt9im7vvC-ggKbTU@bombadil.infradead.org>
References: <20240829123107.520005-1-john.g.garry@oracle.com>
 <Ztl72OINsWHeq4pz@bombadil.infradead.org>
 <316ec2a1-52f8-49e5-9645-f93f3e7c5383@oracle.com>
 <ZtuQVTC4MwdzRDsy@bombadil.infradead.org>
 <76e0cf08-e0ac-4443-b107-86e7d2e4c23d@oracle.com>
 <8e15be46-75af-4d3e-ac75-8c38ec179b0c@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e15be46-75af-4d3e-ac75-8c38ec179b0c@kernel.dk>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Mon, Sep 09, 2024 at 01:48:23PM -0600, Jens Axboe wrote:
> 
> FWIW, Luis, your email gets marked as spam. I think you need to check
> settings. I only see John's replies.

kernel.org has bumped the requirements for spam, and so I need to use
kernel.org for SMTP now.

  Luis
