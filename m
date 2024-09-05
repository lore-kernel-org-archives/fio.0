Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6F42107
	for <fio@vger.kernel.org>; Thu,  5 Sep 2024 09:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529049; cv=none; b=SaZKvcSk8Om+BZY384OYKnp9lY9OZkvr1h/nbD1FEEtdcZUNwe3o6Ziodyl0NQtNCM3i3r75GpyzODzKkNH76yeObNaLR0HEsB+e8AZtWbbd3rM9B7ZBGl2upx6eGnTocpQfuk1WpK3YfoeC//62aS0IkSKetGu1KLTbhYSZdIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529049; c=relaxed/simple;
	bh=adPuqPa9Ak7cJ3TDXfhM1j/G4lpuoi6tRuYaYtN8BRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JVEKXOR8rj8yJm0LxV62foPUyuloyEKzhgMDAtw1aQZz69eYfyRtLW8/cLnLPZCBUusPQYHUUWL7TzH6fbNFDdKnxTG54+MuTFrHx8Zr9IzLb2MT/OQxEwUR8UPbwFVniAncf+fDFdMx8+Fi7VDZgJhuz9S/kTUTStal/j6t8H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CsoaMZPb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CsoaMZPb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WWtji5HAYITxh1rKq5UdIJlzZnyzgGTCz6cD/PS5oOA=; b=CsoaMZPbmPgLNosSWm9kOYQLYU
	wwNNCHq7J+hla1RJrt6veP3Tt9Ym2XxkmbtOLrhoqDWZXkWun30bv3nJKl+ciJswK6Pa0y1EKlTGt
	qMr7zZb/f7pKvbNeogemIs0jDx7Y9jPev++iXNnUFiHWh75EBzE7UkyaTo/OQg0RzvEf9edDBj1ij
	V0dtYc9KHuOLF0x0FbHSFATBY2boACrZTWp8Z1wBXokUpVeBF7d6jFS6/VwXfnc8SQoxg88ip5A2U
	IBNp+9Kxp14DgDdilvRERGpKW3iH+vnK0zM0NsSQbtW+8tcp9pMZ8nRjemmV+/r4KDlh646Al/HdX
	/pu60Cow==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sm8vg-00000007nnV-1EJJ;
	Thu, 05 Sep 2024 09:37:28 +0000
Date: Thu, 5 Sep 2024 02:37:28 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: fio@vger.kernel.org, axboe@kernel.dk, martin.petersen@oracle.com,
	djwong@kernel.org, Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Dan Helmick <dan.helmick@samsung.com>
Subject: Re: [PATCH 0/7] fio: atomic write support
Message-ID: <Ztl72OINsWHeq4pz@bombadil.infradead.org>
References: <20240829123107.520005-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829123107.520005-1-john.g.garry@oracle.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Thu, Aug 29, 2024 at 12:31:00PM +0000, John Garry wrote:
> The verify feature can be useful to prove atomic writes. However, atomic
> writes only ensure a proper CRC, but not sequence number. So sequence
> numbers are ignored in verify mode for atomic writes.

Why not? Note that NVMe TP4098 MAM support (not public yet I think so
I'm not going into details) is outside of scope as the current
RWF_ATOMIC requirements specifically require natural alignment and for
the writes to be between  stx_atomic_write_unit_min (LBA format) and
stx_atomic_write_unit_max (AWUPF) -- why are we not getting sequence
numbers right? Is that a SCSI issue?

> This series is marked as an RFC because:
> - Whether verify mode should ignore sequence number always or we should
>   add a new option for that.

  Luis
