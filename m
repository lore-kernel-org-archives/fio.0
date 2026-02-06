Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576721C84C0
	for <fio@vger.kernel.org>; Fri,  6 Feb 2026 16:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770396065; cv=none; b=V8gv4UzqSQyDoQYsmbmAus1hDwDe4STcEG4ZuSDv7WJtQV28URw2B75fGd8nMZcE104k2yetfU/Y/lO7qJgWj2UlvFMSWltp9dfYsC2PDQxmXd0mltza0jjEGQ2iXRutlVsoPQysSaX6b/9WTZMJCnVzcifXCfA23PLATIuEfAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770396065; c=relaxed/simple;
	bh=K7PkN+VQFNDOJOAdTsk2XGZTCagrGk3DVe1Bi/jqhO0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aksc/zTQ5GvRU0qEhvzYPp1soPj1Yb3csMpNS2dUrcGMt+Ica6ZzFF8uQU9wQmWvmEgv/aUM3aNPD4s1yMLsggUx259H3gyea35/m9qxh+bBZkmyWHkMIrbTBtGMdaZlPbwn0Y3ZeEWx4BMJQfSIo3GEeZ0kbD9Ms5br5U/4mCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hRHhB+r8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hRHhB+r8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96AEC116C6;
	Fri,  6 Feb 2026 16:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770396065;
	bh=K7PkN+VQFNDOJOAdTsk2XGZTCagrGk3DVe1Bi/jqhO0=;
	h=From:To:Cc:Subject:Date:From;
	b=hRHhB+r8fx8BwoQYR1tJ0zMZq2PqFIGy66iWA+9vIi1I2Q94coLD6ibRNBL3SUFxl
	 nFB0KQzq8nJdC9/QPqNJHHs0Yhvv5cWdJ3eD6uWhvzyT9j8T2+7KAAlOXErw73H85B
	 hQ9T35AjfNwD5WsdBRX2EiK0CB8wo+WYG0q+qfw93gb79KSUVZhpwG+ybgUAZXc9JG
	 aasLj7EmUDsmfB/in2JVfcnKe5gWJ1KMmis1nLfzaK0QFwiJKbOYY6FzdfW0ZMYMd5
	 gQy0rQGeD6t4lEpun1YZ5H5Z1ED4SpVy/WykW5ETRhkB8u5S4QGpqcDOtje76ar4wS
	 rH/w8C84IUyWQ==
From: Niklas Cassel <cassel@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Jorgen S Hansen <jorgen.hansen@wdc.com>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 0/3] fio: Avoid errno and errno string mismatch
Date: Fri,  6 Feb 2026 17:40:55 +0100
Message-ID: <20260206164058.3105327-1-cassel@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello all,

This series fixes a problem where errno and error string representing that
errno could be out of sync.

Another possible solution is to remove td->verror everywhere and make sure
that the function wants the error string calls strerror() with the errno
when they actually need it. However, that would be a larger change.

Another optimization that could also be done is to look at the places where
we call update_error_count() and td_clear_error(), if we don't set
td->error for a non-fatal error, there is no reason to unconditionally call
td_clear_error() for a non-fatal error. (update_error_count() still has to
be called, as it sets td->first_error.) However, I do not really understand
why update_error_count() + td_clear_error() is called by both:
io_u.c:io_completed() and backend.c:break_on_this_error(), so I avoided to
do this optimization.


Niklas Cassel (3):
  fio: Fix error string not matching errno
  io_u: Fix inconsistent handling of non-fatal errors with option
    error_dump
  stat: Remove duplicate space in __show_run_stats()

 fio.h  |  7 +++----
 io_u.c | 10 ++++++++--
 stat.c |  2 +-
 3 files changed, 12 insertions(+), 7 deletions(-)

-- 
2.53.0

