Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB06137E
	for <fio@vger.kernel.org>; Mon, 20 Jan 2025 19:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737402401; cv=none; b=cNL2NKGFzCJEP8j6WMdywih7xHOFLLGenn5/o1NoVRXWm48WWrA+5qAlE0/BOY/Azs9Axv3iaXS8hu8ybQqvLKnthhkgMST2x5Lk3CPC2vwzC4p6SoUMJAFgCDQAVgWuaQQWhKNT+bbsL/uAV/ca8GWuy4dIKrvOuccz/W2apZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737402401; c=relaxed/simple;
	bh=TOC3xVKP0QthIQ+tCkSdMt5jCTNDuKtMxTfEbr/WwPs=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=e65MDBzfw05llovg0nD4psuV+URmxBqS6JT+lmIoWHMtPNrMyTWDB86SViYLSdH753u1CT7Vw/St7x2f4MhUV/C9ssjPuLusqsgAZh9sHu9k4qjaur82cP9UF04L5ak9KMZw5xjJIHBGHZHRdLlq9iNzUEE1yjofBU5AIN+nUHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dPsqRjbc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dPsqRjbc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737402398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/UfHAhHsNHd12RHo9Ax143AJiFREAnj90RiK7H74qzU=;
	b=dPsqRjbc+Zs4VzSktDTpO2tbxQ8kPZFKYHqdSXd/xPFOLPjFe4xjO7pZrsVxsJNbwQHa/G
	D+BZdQZD5cvcR+Luz2UlCW/P0XsS4rni/+9KCz79PVD9aCbuGUvcFlkskmlnnBXqU1w6kF
	EBvCnSBaP7RdguW+7dbwLV+VevaTczU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-203-hwnKzXLjPjKhtGPN6duPSw-1; Mon,
 20 Jan 2025 14:46:36 -0500
X-MC-Unique: hwnKzXLjPjKhtGPN6duPSw-1
X-Mimecast-MFC-AGG-ID: hwnKzXLjPjKhtGPN6duPSw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 027591956083;
	Mon, 20 Jan 2025 19:46:35 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.65.209])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29EF519560A3;
	Mon, 20 Jan 2025 19:46:33 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Giuliano G Motter <mottergiuliano@gmail.com>
Cc: fio@vger.kernel.org
Subject: Re: How do I characterize my usecase so that I can simulate it with
 fio the closest?
References: <CAK0q08N-yCNKK9Jsg5h2_Kmm9iEhc95fPuGxYYC-BhK8dkeboQ@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Mon, 20 Jan 2025 14:46:32 -0500
In-Reply-To: <CAK0q08N-yCNKK9Jsg5h2_Kmm9iEhc95fPuGxYYC-BhK8dkeboQ@mail.gmail.com>
	(Giuliano G. Motter's message of "Mon, 20 Jan 2025 08:58:40 -0300")
Message-ID: <x498qr5mfon.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Giuliano G Motter <mottergiuliano@gmail.com> writes:

> At a second moment, tough, I would in fact like to implement a test
> that is the closest as possible to the real process we have during USB
> stick flashing
>
> Question:
> How do I characterize my use case so that I can simulate it with fio?

Have you tried the btrecord and btreplay utilities shipped with
blktrace?  Or, if you are set on using fio, you can replay blktraces
using fio.  See the fio(1) man page section on "I/O replay".

Good luck,
Jeff

