Received: from mx1.arcza.net (infra-nat-2.dmz.arcza.net [81.187.86.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879CF433C8
	for <fio@vger.kernel.org>; Tue, 13 May 2025 18:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.187.86.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747161005; cv=none; b=MjWKCaYH/EQCqH5aYhvZ2wPJnIc4/FHP2c8aWyMBrW2wEtUc2EiC/jsQMM5GUKtjz5hKEdREe3DkNZZTxtcsYB3IJ0NEd7sZ4aOUG4hMihHamt5QgQDRnRN4I1du6wulZptxbihLGcrIfTxtgdym6SKF6Sa2XQgbhXwIBV7Qeqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747161005; c=relaxed/simple;
	bh=aYsy7eVzdEKQtL8acEQVZ6YRg6rVRaeNEqjhdqjOH78=;
	h=Content-Type:From:Mime-Version:Date:Subject:Message-Id:To; b=ARTaocLUVQol87hY0WyAYc1MU/KeMefGudV+dn8plJYg3xEGxp9+YRgXA/AT2bstlyOlq/RA6We8L/mntfCYgnpkVbNA650fXyKyXY7Apl+nrxcKlgXj03zwFiVMUf7p/taXpsvD0GDCC4rVHQy6tS9RjrArm8urEb77/44F1ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arcza.com; spf=pass smtp.mailfrom=arcza.com; dkim=pass (2048-bit key) header.d=arcza.com header.i=@arcza.com header.b=ZnLGE+gj; arc=none smtp.client-ip=81.187.86.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arcza.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arcza.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arcza.com header.i=@arcza.com header.b="ZnLGE+gj"
Received: from mxout1-lon.core.arcza.net (mxout1-lon.core.arcza.net [10.0.13.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mx1.arcza.net (Postfix) with ESMTPS id 9E68B15122B
	for <fio@vger.kernel.org>; Tue, 13 May 2025 19:22:12 +0100 (BST)
Received: from mbx1-lon.core.arcza.net (unknown [10.0.10.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mxout1-lon.core.arcza.net (Postfix) with ESMTPSA id 21CE221975C9
	for <fio@vger.kernel.org>; Tue, 13 May 2025 19:22:12 +0100 (BST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout1-lon.core.arcza.net 21CE221975C9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arcza.com; s=dkim;
	t=1747160532; bh=aYsy7eVzdEKQtL8acEQVZ6YRg6rVRaeNEqjhdqjOH78=;
	h=From:Date:Subject:To:From;
	b=ZnLGE+gjPe/tphL/RMVlZHKdC5MVeOTz9aF1iMHsAFqsYXHHX2PM2DhSk8YDC/oK+
	 VScYULMo0OyszBSeRDGoq7IM90amicd7YhULzXhNvPzYsko6nL1xTzAwd3HauFBbwI
	 aOhpvVUhQn0iU7J2mBJHlunYFkBLMxiyh0iu4bNnpQMIO+gGcLp7SQvxoDcQz1qYdK
	 B4EXWXdFpZbxzs9P0Xo4NtXhRf6TRisMS+kyotmIFrpB9+hhT38L5i84z8Xzr4eSCG
	 +LzlCLr95mgiN86YBR2dOH2rGs0PVoy3ONx3Qwjdl9OIEnL/AIMLD59cbO0tw/osld
	 s7quRR2YiZ0qg==
Received: from smtpclient.apple (unknown [10.1.120.47])
	by mbx1-lon.core.arcza.net (Postfix) with ESMTP id EE00B200C5D4
	for <fio@vger.kernel.org>; Tue, 13 May 2025 19:22:11 +0100 (BST)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Andrew Taylor <andrew@arcza.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Date: Tue, 13 May 2025 19:22:11 +0100
Subject: Unsubscribe
Message-Id: <AC571142-00AE-4D90-98DD-6522D2ED1378@arcza.com>
To: fio@vger.kernel.org
X-Mailer: iPhone Mail (22D82)


Andrew

Sent from a mobile device
