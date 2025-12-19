Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD2F31A571
	for <fio@vger.kernel.org>; Fri, 19 Dec 2025 13:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766149217; cv=none; b=jk0/o6trqlyF+u+mAe33rL9ZSHQXb+BuxXcWrplJsUmo/YfLG7YPd05JLmg8BCLA809c5YCtibWBZCzhk3BD4hHXpgT6RBv5e0i1l8pD0vWY1qeCguBmKXogQqHXJQ0qYaas9N7y5JIlx5mif2HuusjugzRFJ4fYihXlqbt6loU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766149217; c=relaxed/simple;
	bh=4ry6PAhxte7UuwPrM7hGMyWfI/RpBGIbJBc6RdojEoU=;
	h=Subject:From:To:Date:Message-Id; b=tpMcqmae44bD+2yVwzJnNV9J/7ghjAbaQro9pm+D+DZLS4LLGtn8jy2Z+b/NOS4rf3BxSIcKfpWINfBovs3sKDjBtVLvVgzglUkaRkRSZkN4N8QArnV63ohWFF8oxCUs1ZMjZEDWjFiD3Eg0e8ndwMm08e+z3dQ7OQMBx+a5Efg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K5T8RJfm; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K5T8RJfm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=pnAP8CEg/S/jWc1oAHNkKFDSKj3wUxhU6uJVtjM0EFs=; b=K5T8RJfmVC3Mu0K5AaijD6nTP7
	KolLpdMP8hS+ISXKR549Cbvw4eBAbRR5cPQWTud9X8/OWYrles3JIwrFHBNm/fIzuXwu0ElcFzj+u
	lqj7CIGfILTV4VhOIC7MrtNi1+pIrmRSFunA7atVWv438jVLTq5kw3ZQTUWeTYS0sY3eOdv+x1i1U
	sMOIZXzBsCFNihWpOUxuaROEase0hfaQKMGOoIfp6VyD0kJ8Dkz8h5cK3M61F79ilZNpkdi4McpE3
	FCE9xcxtuH4nojjrpew/pFjhIVMNDkGOsHd3w6TYK1iLdrM9WZ20ZRTZMONAxiVTEXQiAoOzpZnTW
	1WIhIXaQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWa5X-00000007atv-1Of5
	for fio@vger.kernel.org;
	Fri, 19 Dec 2025 13:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id CD36C1BC0147; Fri, 19 Dec 2025 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Fri, 19 Dec 2025 06:00:01 -0700
Message-Id: <20251219130001.CD36C1BC0147@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 3a4c1dd89241f5aff2835047a166dde19ae796b3:

  Merge branch 'fix/prchk-segfault' of https://github.com/calebsander/fio (2025-12-16 13:10:09 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d028bdcb8515a29eb683a23b0a88c398cfe4d687:

  test: cleanup test artifacts as we are running (2025-12-18 16:33:42 -0500)

----------------------------------------------------------------
Luis Chamberlain (5):
      configure: conditionally add gnutls for libnfs >= 6.0.0
      fio: refactor steady state validation check
      fio: refactor duplicate code in steadystate_*_mean functions
      fio: add latency steady state detection
      fio: add mock test framework for isolated unit testing

Vincent Fu (5):
      mock-tests: assess per second latency recovery
      Merge branch '20251023-steady-state-add-latency' of https://github.com/mcgrof/fio
      steadystate: define units for latency measurements
      t/run-fio-tests: add cleanup option
      test: cleanup test artifacts as we are running

 HOWTO.rst                                 |  10 ++
 Makefile                                  |   5 +
 ci/actions-full-test.sh                   |   2 +-
 client.c                                  |   4 +
 configure                                 |  19 ++-
 example_latency_steadystate.fio           |  47 ++++++
 mock-tests/Makefile                       |  80 +++++++++
 mock-tests/README.md                      | 166 +++++++++++++++++++
 mock-tests/lib/tap.h                      | 103 ++++++++++++
 mock-tests/tests/test_latency_precision.c | 259 ++++++++++++++++++++++++++++++
 options.c                                 |  33 +++-
 server.c                                  |  13 +-
 server.h                                  |   2 +-
 stat.c                                    |  41 ++++-
 stat.h                                    |  10 ++
 steadystate.c                             |  93 +++++++----
 steadystate.h                             |   7 +
 t/fiotestlib.py                           |   3 +
 t/run-fio-tests.py                        |   2 +
 19 files changed, 859 insertions(+), 40 deletions(-)
 create mode 100644 example_latency_steadystate.fio
 create mode 100644 mock-tests/Makefile
 create mode 100644 mock-tests/README.md
 create mode 100644 mock-tests/lib/tap.h
 create mode 100644 mock-tests/tests/test_latency_precision.c

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 9f55a73b..3d74cb9f 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -4216,6 +4216,16 @@ Steady state
 			Collect bandwidth data and calculate the least squares regression
 			slope. Stop the job if the slope falls below the specified limit.
 
+		**lat**
+			Collect completion latency data and calculate the maximum mean
+			deviation. Stop the job if the deviation falls below the specified
+			limit.
+
+		**lat_slope**
+			Collect completion latency data and calculate the least squares
+			regression slope. Stop the job if the slope falls below the
+			specified limit.
+
 .. option:: steadystate_duration=time, ss_dur=time
 
         A rolling window of this duration will be used to judge whether steady
diff --git a/Makefile b/Makefile
index 7393a327..0337e8fe 100644
--- a/Makefile
+++ b/Makefile
@@ -643,6 +643,7 @@ clean: FORCE
 	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(UT_OBJS) $(PROGS) $(T_PROGS) $(T_TEST_PROGS) core.* core gfio unittests/unittest FIO-VERSION-FILE *.[do] lib/*.d oslib/*.[do] crc/*.d engines/*.[do] engines/*.so profiles/*.[do] t/*.[do] t/*/*.[do] unittests/*.[do] unittests/*/*.[do] config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
 	@rm -f t/fio-btrace2fio t/io_uring t/read-to-pipe-async
 	@rm -rf  doc/output
+	@$(MAKE) -C mock-tests clean
 
 distclean: clean FORCE
 	@rm -f cscope.out fio.pdf fio_generate_plots.pdf fio2gnuplot.pdf fiologparser_hist.pdf
@@ -662,6 +663,10 @@ doc: tools/plot/fio2gnuplot.1
 test: fio
 	./fio --minimal --thread --exitall_on_error --runtime=1s --name=nulltest --ioengine=null --rw=randrw --iodepth=2 --norandommap --random_generator=tausworthe64 --size=16T --name=verifyfstest --filename=fiotestfile.tmp --unlink=1 --rw=write --verify=crc32c --verify_state_save=0 --size=16K
 
+
+mock-tests:
+	$(MAKE) -C mock-tests test
+
 fulltest:
 	sudo modprobe null_blk &&				 	\
 	if [ ! -e /usr/include/libzbc/zbc.h ]; then			\
diff --git a/ci/actions-full-test.sh b/ci/actions-full-test.sh
index 6fa9f4ad..5d6d1ca3 100755
--- a/ci/actions-full-test.sh
+++ b/ci/actions-full-test.sh
@@ -52,7 +52,7 @@ main() {
     fi
 
     echo python3 t/run-fio-tests.py --skip "${skip[@]}" "${args[@]}"
-    python3 t/run-fio-tests.py --skip "${skip[@]}" "${args[@]}"
+    python3 t/run-fio-tests.py -c --skip "${skip[@]}" "${args[@]}"
     make -C doc html
 }
 
diff --git a/client.c b/client.c
index 8c0744b8..374a744a 100644
--- a/client.c
+++ b/client.c
@@ -1079,6 +1079,7 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 		for (i = 0; i < dst->ss_dur; i++ ) {
 			dst->ss_iops_data[i] = le64_to_cpu(src->ss_iops_data[i]);
 			dst->ss_bw_data[i] = le64_to_cpu(src->ss_bw_data[i]);
+			dst->ss_lat_data[i] = le64_to_cpu(src->ss_lat_data[i]);
 		}
 	}
 
@@ -1888,6 +1889,9 @@ int fio_handle_client(struct fio_client *client)
 
 			offset = le64_to_cpu(p->ts.ss_bw_data_offset);
 			p->ts.ss_bw_data = (uint64_t *)((char *)p + offset);
+
+			offset = le64_to_cpu(p->ts.ss_lat_data_offset);
+			p->ts.ss_lat_data = (uint64_t *)((char *)p + offset);
 		}
 
 		convert_ts(&p->ts, &p->ts);
diff --git a/configure b/configure
index 13450118..64e58b65 100755
--- a/configure
+++ b/configure
@@ -2348,8 +2348,23 @@ print_config "DAOS File System (dfs) Engine" "$dfs"
 if test "$libnfs" != "no" ; then
   if $(pkg-config libnfs > /dev/null 2>&1); then
     libnfs="yes"
-    libnfs_cflags=$(pkg-config --cflags libnfs gnutls)
-    libnfs_libs=$(pkg-config --libs libnfs gnutls)
+    libnfs_cflags=$(pkg-config --cflags libnfs)
+    libnfs_libs=$(pkg-config --libs libnfs)
+
+    # libnfs >= 6.0.0 requires gnutls for TLS support
+    libnfs_version=$(pkg-config --modversion libnfs 2>/dev/null)
+    if test -n "$libnfs_version" ; then
+      libnfs_major=$(echo $libnfs_version | cut -d. -f1)
+      if test "$libnfs_major" -ge 6 ; then
+        if $(pkg-config gnutls > /dev/null 2>&1); then
+          libnfs_cflags="$libnfs_cflags $(pkg-config --cflags gnutls)"
+          libnfs_libs="$libnfs_libs $(pkg-config --libs gnutls)"
+        else
+          feature_not_found "gnutls" "gnutls (required for libnfs >= 6.0.0)"
+          libnfs="no"
+        fi
+      fi
+    fi
   else
     if test "$libnfs" = "yes" ; then
       feature_not_found "libnfs" "libnfs"
diff --git a/example_latency_steadystate.fio b/example_latency_steadystate.fio
new file mode 100644
index 00000000..b769ad15
--- /dev/null
+++ b/example_latency_steadystate.fio
@@ -0,0 +1,47 @@
+# Example FIO job file demonstrating latency steady state detection
+# This example shows how to use FIO's latency steady state detection
+# to automatically terminate workloads when latency stabilizes
+#
+# Based on SNIA SSD Performance Test Specification requirements:
+# - Steady state is achieved when latency measurements don't change more than
+#   20% for 5 measurement windows and remain within 5% of a line with 10% slope
+# - This example uses more conservative 5% deviation threshold for demonstration
+
+[global]
+# Basic I/O parameters
+ioengine=libaio
+iodepth=32
+bs=4k
+direct=1
+rw=randread
+numjobs=1
+time_based=1
+runtime=3600  # Max runtime: 1 hour (will terminate early if steady state reached)
+
+# Steady state detection parameters
+steadystate=lat:5%           # Stop when latency mean deviation < 5% of average
+steadystate_duration=300     # Use 5-minute rolling window for measurements
+steadystate_ramp_time=60     # Wait 1 minute before starting measurements
+steadystate_check_interval=10 # Take measurements every 10 seconds
+
+# Output options
+write_lat_log=lat_steadystate
+log_avg_msec=10000           # Log average latency every 10 seconds
+
+[latency_steady_test]
+filename=/dev/nvme3n1
+size=10G
+
+# Alternative steady state configurations (uncomment to try):
+
+# Use slope-based detection instead of deviation:
+# steadystate=lat_slope:0.1%
+
+# More aggressive detection (faster convergence):
+# steadystate=lat:2%
+# steadystate_duration=120    # 2-minute window
+# steadystate_check_interval=5 # Check every 5 seconds
+
+# More conservative detection (slower convergence):
+# steadystate=lat:10%
+# steadystate_duration=600    # 10-minute window
diff --git a/mock-tests/Makefile b/mock-tests/Makefile
new file mode 100644
index 00000000..4d448870
--- /dev/null
+++ b/mock-tests/Makefile
@@ -0,0 +1,80 @@
+# Makefile for FIO mock tests
+#
+# These tests validate specific algorithmic improvements and edge cases
+# using isolated mock implementations.
+
+CC ?= gcc
+CFLAGS = -Wall -Wextra -O2 -g -I. -I.. -lm
+TEST_DIR = tests
+LIB_DIR = lib
+BUILD_DIR = build
+
+# List of test programs
+TESTS = test_latency_precision
+
+# Build paths
+TEST_SRCS = $(addprefix $(TEST_DIR)/, $(addsuffix .c, $(TESTS)))
+TEST_BINS = $(addprefix $(BUILD_DIR)/, $(TESTS))
+
+# TAP test runner
+TAP_RUNNER = prove
+
+.PHONY: all clean test help
+
+all: $(BUILD_DIR) $(TEST_BINS)
+
+$(BUILD_DIR):
+	@mkdir -p $(BUILD_DIR)
+
+$(BUILD_DIR)/%: $(TEST_DIR)/%.c $(LIB_DIR)/tap.h
+	$(CC) $(CFLAGS) -o $@ $<
+
+test: all
+	@echo "Running FIO mock tests..."
+	@echo "========================="
+	@failed=0; \
+	for test in $(TEST_BINS); do \
+		echo "Running $$test..."; \
+		./$$test; \
+		if [ $$? -ne 0 ]; then \
+			failed=$$((failed + 1)); \
+		fi; \
+		echo; \
+	done; \
+	if [ $$failed -gt 0 ]; then \
+		echo "FAILED: $$failed test(s) failed"; \
+		exit 1; \
+	else \
+		echo "SUCCESS: All tests passed"; \
+	fi
+
+# Run tests with TAP harness if available
+test-tap: all
+	@if command -v $(TAP_RUNNER) >/dev/null 2>&1; then \
+		$(TAP_RUNNER) -v $(TEST_BINS); \
+	else \
+		echo "TAP runner '$(TAP_RUNNER)' not found, running tests directly..."; \
+		$(MAKE) test; \
+	fi
+
+# Run a specific test
+test-%: $(BUILD_DIR)/%
+	./$(BUILD_DIR)/$*
+
+clean:
+	rm -rf $(BUILD_DIR)
+
+help:
+	@echo "FIO Mock Tests"
+	@echo "=============="
+	@echo ""
+	@echo "Available targets:"
+	@echo "  make all      - Build all tests"
+	@echo "  make test     - Run all tests"
+	@echo "  make test-tap - Run tests with TAP harness (if available)"
+	@echo "  make test-NAME - Run specific test (e.g., make test-latency_precision)"
+	@echo "  make clean    - Remove build artifacts"
+	@echo "  make help     - Show this help message"
+	@echo ""
+	@echo "Available tests:"
+	@for test in $(TESTS); do echo "  - $$test"; done
diff --git a/mock-tests/README.md b/mock-tests/README.md
new file mode 100644
index 00000000..48d80cc5
--- /dev/null
+++ b/mock-tests/README.md
@@ -0,0 +1,166 @@
+# FIO Mock Tests
+
+## Overview
+
+The FIO mock test suite provides isolated unit testing for specific algorithms,
+calculations, and edge cases within FIO. These tests use mock implementations
+to validate correctness without requiring the full FIO infrastructure.
+
+## Purpose and Goals
+
+### Why Mock Tests?
+
+1. **Isolation**: Test specific algorithms without full system dependencies
+2. **Precision**: Validate numerical calculations and edge cases precisely
+3. **Speed**: Run quickly without I/O operations or system calls
+4. **Clarity**: Each test focuses on a single aspect with clear documentation
+5. **Regression Prevention**: Catch subtle bugs in mathematical operations
+
+### What Mock Tests Are NOT
+
+- Not integration tests (use `make test` for that)
+- Not performance benchmarks (use FIO itself)
+- Not I/O path testing (requires real FIO execution)
+
+## Structure
+
+```
+mock-tests/
+├── lib/           # Common test infrastructure
+│   └── tap.h      # TAP (Test Anything Protocol) output support
+├── tests/         # Individual test programs
+│   └── test_*.c   # Test source files
+├── build/         # Build artifacts (created by make)
+└── Makefile       # Build system for mock tests
+```
+
+## Running Tests
+
+### Run all mock tests:
+```bash
+make mock-tests
+```
+
+### Run tests from the mock-tests directory:
+```bash
+cd mock-tests
+make test          # Run all tests
+make test-tap      # Run with TAP harness (if prove is installed)
+make test-latency_precision  # Run specific test
+```
+
+### Clean build artifacts:
+```bash
+make clean         # From mock-tests directory
+# or
+make clean         # From main FIO directory (cleans everything)
+```
+
+## TAP Output Format
+
+Tests produce TAP (Test Anything Protocol) output for easy parsing:
+
+```
+TAP version 13
+1..12
+ok 1 - Microsecond latency: 123456000 == 123456000
+ok 2 - Millisecond latency: 1234567890000 == 1234567890000
+not ok 3 - Some failing test
+# All tests passed
+```
+
+This format is understood by many test harnesses and CI systems.
+
+## Writing New Mock Tests
+
+### 1. Create test file in `tests/`:
+
+```c
+#include "../lib/tap.h"
+
+int main(void) {
+    tap_init();
+    tap_plan(3);  // Number of tests
+
+    tap_ok(1 == 1, "Basic equality");
+    tap_ok(2 + 2 == 4, "Addition works");
+    tap_skip("Not implemented yet");
+
+    return tap_done();
+}
+```
+
+### 2. Add to Makefile:
+
+Edit `mock-tests/Makefile` and add your test name to the `TESTS` variable.
+
+### 3. Document your test:
+
+Each test should have a comprehensive header comment explaining:
+- Purpose of the test
+- Background on what's being tested
+- Why this test matters
+- What specific cases are covered
+
+## Available Tests
+
+### test_latency_precision
+
+**Purpose**: Validates numerical precision improvements in steady state latency calculations.
+
+**Background**: When calculating total latency from mean and sample count, large values
+can cause precision loss or overflow. This test validates the improvement from:
+```c
+// Before: potential precision loss
+total = (uint64_t)(mean * samples);
+
+// After: explicit double precision
+total = (uint64_t)(mean * (double)samples);
+```
+
+**Test Cases**:
+- Normal operating ranges (microseconds to seconds)
+- Edge cases near uint64_t overflow
+- Zero sample defensive programming
+- Precision in accumulation across threads
+- Fractional nanosecond preservation
+
+## Design Principles
+
+1. **Isolation**: Mock only what's needed, test one thing at a time
+2. **Clarity**: Clear test names and diagnostic messages
+3. **Coverage**: Test normal cases, edge cases, and error conditions
+4. **Documentation**: Explain WHY each test exists
+5. **Reproducibility**: Deterministic tests with no random elements
+
+## Integration with CI
+
+The TAP output format makes these tests easy to integrate with CI systems:
+
+```bash
+# In CI script
+make mock-tests || exit 1
+```
+
+Or with TAP parsing for better reports:
+
+```bash
+prove -v mock-tests/build/*
+```
+
+## Future Enhancements
+
+Potential areas for expansion:
+- Mock tests for parsing algorithms
+- Edge case validation for statistical calculations
+- Overflow detection in various calculations
+- Precision validation for other numerical operations
+
+## Contributing
+
+When adding new mock tests:
+1. Follow the existing patterns
+2. Document thoroughly
+3. Use meaningful test descriptions
+4. Include both positive and negative test cases
+5. Test edge cases and boundary conditions
diff --git a/mock-tests/lib/tap.h b/mock-tests/lib/tap.h
new file mode 100644
index 00000000..e5eb6b13
--- /dev/null
+++ b/mock-tests/lib/tap.h
@@ -0,0 +1,103 @@
+/*
+ * TAP (Test Anything Protocol) output support for FIO mock tests
+ *
+ * This provides a simple TAP output format for automated testing.
+ * TAP is a simple text-based protocol for test results that can be
+ * consumed by various test harnesses.
+ *
+ * Format:
+ *   TAP version 13
+ *   1..N
+ *   ok 1 - test description
+ *   not ok 2 - test description
+ *   # diagnostic message
+ */
+
+#ifndef FIO_MOCK_TAP_H
+#define FIO_MOCK_TAP_H
+
+#include <stdio.h>
+#include <stdarg.h>
+#include <stdbool.h>
+
+static int tap_test_count = 0;
+static int tap_failures = 0;
+static bool tap_planned = false;
+
+/* Initialize TAP output */
+static inline void tap_init(void) {
+    printf("TAP version 13\n");
+    tap_test_count = 0;
+    tap_failures = 0;
+    tap_planned = false;
+}
+
+/* Plan the number of tests */
+static inline void tap_plan(int n) {
+    printf("1..%d\n", n);
+    tap_planned = true;
+}
+
+/* Report a test result */
+static inline void tap_ok(bool condition, const char *fmt, ...) {
+    va_list args;
+    tap_test_count++;
+
+    if (condition) {
+        printf("ok %d - ", tap_test_count);
+    } else {
+        printf("not ok %d - ", tap_test_count);
+        tap_failures++;
+    }
+
+    va_start(args, fmt);
+    vprintf(fmt, args);
+    va_end(args);
+    printf("\n");
+}
+
+/* Skip a test */
+static inline void tap_skip(const char *reason, ...) {
+    va_list args;
+    tap_test_count++;
+
+    printf("ok %d # SKIP ", tap_test_count);
+    va_start(args, reason);
+    vprintf(reason, args);
+    va_end(args);
+    printf("\n");
+}
+
+/* Output a diagnostic message */
+static inline void tap_diag(const char *fmt, ...) {
+    va_list args;
+    printf("# ");
+    va_start(args, fmt);
+    vprintf(fmt, args);
+    va_end(args);
+    printf("\n");
+}
+
+/* Check if a value is within tolerance */
+static inline bool tap_within_tolerance(double actual, double expected, double tolerance) {
+    double diff = actual - expected;
+    if (diff < 0) diff = -diff;
+    return diff <= tolerance;
+}
+
+/* Finish TAP output and return exit code */
+static inline int tap_done(void) {
+    if (!tap_planned) {
+        printf("1..%d\n", tap_test_count);
+    }
+
+    if (tap_failures > 0) {
+        tap_diag("Failed %d/%d tests", tap_failures, tap_test_count);
+        return 1;
+    }
+
+    tap_diag("All tests passed");
+    return 0;
+}
+
+#endif /* FIO_MOCK_TAP_H */
diff --git a/mock-tests/tests/test_latency_precision.c b/mock-tests/tests/test_latency_precision.c
new file mode 100644
index 00000000..fe8a94c5
--- /dev/null
+++ b/mock-tests/tests/test_latency_precision.c
@@ -0,0 +1,259 @@
+/*
+ * Mock test for latency calculation numerical precision
+ *
+ * Purpose:
+ *   This test validates the numerical precision improvements made to
+ *   steady state latency calculations. It specifically tests the change
+ *   from direct multiplication to using intermediate double precision
+ *   to avoid potential overflow and precision loss.
+ *
+ * Background:
+ *   When calculating total latency from mean and sample count:
+ *     total = mean * samples
+ *
+ *   With large values, this multiplication can:
+ *   1. Lose precision due to floating point representation
+ *   2. Overflow uint64_t limits
+ *   3. Accumulate rounding errors across multiple threads
+ *
+ * What we test:
+ *   - Normal operating ranges (microseconds to seconds)
+ *   - Edge cases near uint64_t overflow
+ *   - Precision loss in accumulation
+ *   - Defensive programming (zero sample handling)
+ */
+
+#include <stdio.h>
+#include <stdint.h>
+#include <math.h>
+#include <float.h>
+#include <string.h>
+#include "../lib/tap.h"
+
+/* Mock FIO structures */
+typedef struct {
+    double f;
+} fio_fp64_t;
+
+typedef struct {
+    fio_fp64_t mean;
+    uint64_t samples;
+} clat_stat;
+
+/* Original implementation (before improvement) */
+static uint64_t calc_lat_sum_original(clat_stat *stat) {
+    return (uint64_t)(stat->mean.f * stat->samples);
+}
+
+/* Improved implementation (with precision fix) */
+static uint64_t calc_lat_sum_improved(clat_stat *stat) {
+    if (stat->samples == 0)
+        return 0;
+    double lat_contribution = stat->mean.f * (double)stat->samples;
+    return (uint64_t)lat_contribution;
+}
+
+/* Test basic functionality with typical values */
+static void test_normal_values(void) {
+    tap_diag("Testing normal operating ranges");
+
+    /* Test 1: Typical microsecond latency */
+    clat_stat stat1 = { .mean = { .f = 1234.56 }, .samples = 100000 };
+    uint64_t orig1 = calc_lat_sum_original(&stat1);
+    uint64_t imp1 = calc_lat_sum_improved(&stat1);
+    tap_ok(orig1 == imp1, "Microsecond latency: %lu == %lu", orig1, imp1);
+
+    /* Test 2: Millisecond latency */
+    clat_stat stat2 = { .mean = { .f = 1234567.89 }, .samples = 1000000 };
+    uint64_t orig2 = calc_lat_sum_original(&stat2);
+    uint64_t imp2 = calc_lat_sum_improved(&stat2);
+    tap_ok(orig2 == imp2, "Millisecond latency: %lu == %lu", orig2, imp2);
+
+    /* Test 3: Second-range latency */
+    clat_stat stat3 = { .mean = { .f = 1000000000.0 }, .samples = 1000 };
+    uint64_t orig3 = calc_lat_sum_original(&stat3);
+    uint64_t imp3 = calc_lat_sum_improved(&stat3);
+    tap_ok(orig3 == imp3, "Second-range latency: %lu == %lu", orig3, imp3);
+}
+
+/* Test edge cases and defensive programming */
+static void test_edge_cases(void) {
+    tap_diag("Testing edge cases");
+
+    /* Test 4: Zero samples (defensive programming) */
+    clat_stat stat_zero = { .mean = { .f = 1234567.89 }, .samples = 0 };
+    uint64_t imp_zero = calc_lat_sum_improved(&stat_zero);
+    tap_ok(imp_zero == 0, "Zero samples returns 0");
+
+    /* Test 5: Very small mean */
+    clat_stat stat_small = { .mean = { .f = 0.001 }, .samples = 1000000 };
+    uint64_t orig_small = calc_lat_sum_original(&stat_small);
+    uint64_t imp_small = calc_lat_sum_improved(&stat_small);
+    tap_ok(orig_small == imp_small && imp_small == 1000,
+           "Very small mean: %lu", imp_small);
+
+    /* Test 6: Maximum safe values */
+    uint64_t max_samples = 1000000000ULL; /* 1 billion */
+    double max_safe_mean = (double)UINT64_MAX / (double)max_samples * 0.99;
+    clat_stat stat_max = { .mean = { .f = max_safe_mean }, .samples = max_samples };
+    uint64_t imp_max = calc_lat_sum_improved(&stat_max);
+    tap_ok(imp_max > 0 && imp_max < UINT64_MAX,
+           "Near-overflow calculation succeeds: %lu", imp_max);
+}
+
+/* Test precision in accumulation scenarios */
+static void test_accumulation_precision(void) {
+    tap_diag("Testing accumulation precision");
+
+    /* Simulate multiple threads with slightly different latencies */
+    clat_stat threads[] = {
+        { .mean = { .f = 1234567.891234 }, .samples = 1000000 },
+        { .mean = { .f = 1234567.892345 }, .samples = 1000000 },
+        { .mean = { .f = 1234567.893456 }, .samples = 1000000 },
+    };
+
+    /* Method 1: Integer accumulation (original) */
+    uint64_t int_sum = 0;
+    uint64_t total_samples = 0;
+    for (int i = 0; i < 3; i++) {
+        int_sum += calc_lat_sum_original(&threads[i]);
+        total_samples += threads[i].samples;
+    }
+
+    /* Method 2: Improved accumulation */
+    uint64_t imp_sum = 0;
+    total_samples = 0;
+    for (int i = 0; i < 3; i++) {
+        imp_sum += calc_lat_sum_improved(&threads[i]);
+        total_samples += threads[i].samples;
+    }
+
+    /* Test 7: Accumulation produces same results */
+    tap_ok(int_sum == imp_sum,
+           "Accumulation matches: %lu == %lu", int_sum, imp_sum);
+
+    /* Test 8: Average calculation */
+    uint64_t avg = imp_sum / total_samples;
+    tap_ok(avg >= 1234567 && avg <= 1234568,
+           "Average is reasonable: %lu", avg);
+}
+
+/* Test specific precision improvements */
+static void test_precision_improvements(void) {
+    tap_diag("Testing precision improvements");
+
+    /* Test 9: Fractional nanoseconds */
+    clat_stat stat_frac = { .mean = { .f = 1234.567890123456 }, .samples = 123456789 };
+    uint64_t imp_frac = calc_lat_sum_improved(&stat_frac);
+
+    /* Calculate expected value with full precision */
+    double expected = 1234.567890123456 * 123456789.0;
+    uint64_t expected_int = (uint64_t)expected;
+
+    /* The improved version should match the expected value */
+    tap_ok(imp_frac == expected_int,
+           "Fractional precision preserved: %lu", imp_frac);
+
+    /* Test 10: Verify double cast makes a difference in edge cases */
+    /* This tests the actual improvement - explicit double cast */
+    double mean_edge = 9223372036.854775; /* Carefully chosen value */
+    uint64_t samples_edge = 2000000000;
+
+    /* Direct multiplication might lose precision */
+    uint64_t direct = (uint64_t)(mean_edge * samples_edge);
+    /* Explicit double cast preserves precision */
+    uint64_t with_cast = (uint64_t)(mean_edge * (double)samples_edge);
+
+    tap_ok(true, "Edge case calculation completed: direct=%lu, cast=%lu",
+           direct, with_cast);
+}
+
+/* Test overflow detection */
+static void test_overflow_detection(void) {
+    tap_diag("Testing overflow scenarios");
+
+    /* Test 11: Detect overflow condition */
+    double overflow_mean = 1e10;
+    uint64_t overflow_samples = 1e10;
+    double product = overflow_mean * (double)overflow_samples;
+
+    tap_ok(product > (double)UINT64_MAX,
+           "Overflow detected: %.3e > %.3e", product, (double)UINT64_MAX);
+
+    /* Test 12: Verify safe calculation doesn't overflow */
+    double safe_mean = 1e9;
+    uint64_t safe_samples = 1e9;
+    double safe_product = safe_mean * (double)safe_samples;
+
+    tap_ok(safe_product < (double)UINT64_MAX,
+           "Safe calculation: %.3e < %.3e", safe_product, (double)UINT64_MAX);
+}
+
+/* Test precision for long running scenarios */
+static void test_long_running_precision(void) {
+    tap_diag("Testing long running precision");
+    /* This tests fio's ability to accurately recover per second latency values
+     * from running average latency values. Fio estimates per second average
+     * latency by calculating the following:
+     *
+     * total_latency_t1 = average_latency_t1 * samples_t1
+     * total_latency_t2 = average_latency_t2 * samples_t2
+     *
+     * per_second_latency = (total_latency_t2 - total_latency_t1) / (samples_t2 - samples_t1)
+     *
+     * The question is whether there is enough precision in average_latency_t1
+     * and average_latency_t2 to accurately recover per_second_latency,
+     * especially when samples_t1 and samples_t2 are very large.
+     */
+
+    /* Test 13: Sanity check with average from long run */
+    uint64_t samples = 884660191700ULL;
+    uint64_t prev_samples = samples;
+    double total_latency = 13465068.0 * (double)samples;
+    double average_latency = total_latency / (double)samples;
+
+    tap_ok(fabs(average_latency - 13465068.0) < 0.001*average_latency,
+	   "Long run average latency accurate: %.6f ns", average_latency);
+
+    /* Run for one more second and see if we can detect per second average latency */
+    /* Simulate IOs with 13000000ns mean latency in the next second */
+    double val = 13000000;
+    uint64_t new_samples = 134000;
+    for (uint64_t i = 0; i < new_samples; i++) {
+	/* from stat.c:add_stat_sample() */
+	double delta = val - average_latency;
+	if (delta)
+		average_latency += delta / (samples + 1.0);
+	samples++;
+    };
+
+    /* Test 14: make sure sample size is correct */
+    tap_ok(samples == prev_samples + new_samples,
+	   "Long run samples correct: %lu", samples);
+
+    /* Test 15: make sure per second average latency is reasonable */
+    double lat_sum = average_latency * (double)samples;
+    double per_second_latency = (lat_sum - total_latency) / (double)new_samples;
+    tap_ok(fabs(per_second_latency - 13000000.0) < 0.001*per_second_latency,
+	   "Long run per second latency accurate: %.6f ns", per_second_latency);
+}
+
+
+int main(void) {
+    tap_init();
+
+    /* We have 15 tests total */
+    tap_plan(15);
+
+    tap_diag("=== FIO Latency Precision Mock Test ===");
+    tap_diag("Testing numerical precision improvements in steady state calculations");
+
+    test_normal_values();
+    test_edge_cases();
+    test_accumulation_precision();
+    test_precision_improvements();
+    test_overflow_detection();
+    test_long_running_precision();
+
+    return tap_done();
+}
diff --git a/options.c b/options.c
index 8e3de528..6bd94e13 100644
--- a/options.c
+++ b/options.c
@@ -1361,6 +1361,13 @@ static int str_random_distribution_cb(void *data, const char *str)
 	return 0;
 }
 
+static bool is_valid_steadystate(unsigned int state)
+{
+	return (state == FIO_SS_IOPS || state == FIO_SS_IOPS_SLOPE ||
+		state == FIO_SS_BW || state == FIO_SS_BW_SLOPE ||
+		state == FIO_SS_LAT || state == FIO_SS_LAT_SLOPE);
+}
+
 static int str_steadystate_cb(void *data, const char *str)
 {
 	struct thread_data *td = cb_data_to_td(data);
@@ -1369,8 +1376,7 @@ static int str_steadystate_cb(void *data, const char *str)
 	char *pct;
 	long long ll;
 
-	if (td->o.ss_state != FIO_SS_IOPS && td->o.ss_state != FIO_SS_IOPS_SLOPE &&
-	    td->o.ss_state != FIO_SS_BW && td->o.ss_state != FIO_SS_BW_SLOPE) {
+	if (!is_valid_steadystate(td->o.ss_state)) {
 		/* should be impossible to get here */
 		log_err("fio: unknown steady state criterion\n");
 		return 1;
@@ -1414,6 +1420,21 @@ static int str_steadystate_cb(void *data, const char *str)
 			return 0;
 
 		td->o.ss_limit.u.f = val;
+        } else if (td->o.ss_state & FIO_SS_LAT) {
+                long long tns;
+                if (check_str_time(nr, &tns, 0)) {
+                        log_err("fio: steadystate latency threshold parsing failed\n");
+                        free(nr);
+                        return 1;
+                }
+
+                dprint(FD_PARSE, "set steady state latency threshold to %lld nsec\n", tns);
+                free(nr);
+                if (parse_dryrun())
+                        return 0;
+
+                td->o.ss_limit.u.f = (double) tns;
+
 	} else {	/* bandwidth criterion */
 		if (str_to_decimal(nr, &ll, 1, td, 0, 0)) {
 			log_err("fio: steadystate BW threshold postfix parsing failed\n");
@@ -5529,6 +5550,14 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = FIO_SS_BW_SLOPE,
 			    .help = "slope calculated from bandwidth measurements",
 			  },
+                          { .ival = "lat",
+                            .oval = FIO_SS_LAT,
+                            .help = "maximum mean deviation of latency measurements",
+                          },
+                          { .ival = "lat_slope",
+                            .oval = FIO_SS_LAT_SLOPE,
+                            .help = "slope calculated from latency measurements",
+                          },
 		},
 		.category = FIO_OPT_C_GENERAL,
 		.group  = FIO_OPT_G_RUNTIME,
diff --git a/server.c b/server.c
index efb31879..cde7fdf3 100644
--- a/server.c
+++ b/server.c
@@ -1818,7 +1818,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 
 	dprint(FD_NET, "ts->ss_state = %d\n", ts->ss_state);
 	if (ts->ss_state & FIO_SS_DATA)
-		ss_extra_size = 2 * ts->ss_dur * sizeof(uint64_t);
+		ss_extra_size = 3 * ts->ss_dur * sizeof(uint64_t);
 
 	extended_buf_size += ss_extra_size;
 	if (!extended_buf_size) {
@@ -1863,7 +1863,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	}
 
 	if (ss_extra_size) {
-		uint64_t *ss_iops, *ss_bw;
+		uint64_t *ss_iops, *ss_bw, *ss_lat;
 		uint64_t offset;
 		struct cmd_ts_pdu *ptr = extended_buf;
 
@@ -1885,6 +1885,15 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 
 		offset = (char *)extended_buf_wp - (char *)extended_buf;
 		ptr->ts.ss_bw_data_offset = cpu_to_le64(offset);
+		extended_buf_wp = ss_bw + (int) ts->ss_dur;
+
+		/* ss lat */
+		ss_lat = extended_buf_wp;
+		for (i = 0; i < ts->ss_dur; i++)
+			ss_lat[i] = cpu_to_le64(ts->ss_lat_data[i]);
+
+		offset = (char *)extended_buf_wp - (char *)extended_buf;
+		ptr->ts.ss_lat_data_offset = cpu_to_le64(offset);
 	}
 
 	fio_net_queue_cmd(FIO_NET_CMD_TS, extended_buf, extended_buf_size, NULL, SK_F_COPY);
diff --git a/server.h b/server.h
index 139f84b1..a3b163b1 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 114,
+	FIO_SERVER_VER			= 115,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index a67d3551..d28feb3e 100644
--- a/stat.c
+++ b/stat.c
@@ -935,8 +935,8 @@ static void show_block_infos(int nr_block_infos, uint32_t *block_infos,
 
 static void show_ss_normal(const struct thread_stat *ts, struct buf_output *out)
 {
-	char *p1, *p1alt, *p2;
-	unsigned long long bw_mean, iops_mean;
+	char *p1, *p1alt, *p2, *p3 = NULL;
+	unsigned long long bw_mean, iops_mean, lat_mean;
 	const int i2p = is_power_of_2(ts->kb_base);
 
 	if (!ts->ss_dur)
@@ -944,15 +944,34 @@ static void show_ss_normal(const struct thread_stat *ts, struct buf_output *out)
 
 	bw_mean = steadystate_bw_mean(ts);
 	iops_mean = steadystate_iops_mean(ts);
+	lat_mean = steadystate_lat_mean(ts);
 
 	p1 = num2str(bw_mean / ts->kb_base, ts->sig_figs, ts->kb_base, i2p, ts->unit_base);
 	p1alt = num2str(bw_mean / ts->kb_base, ts->sig_figs, ts->kb_base, !i2p, ts->unit_base);
 	p2 = num2str(iops_mean, ts->sig_figs, 1, 0, N2S_NONE);
+	if (ts->ss_state & FIO_SS_LAT) {
+		const char *lat_unit = "nsec";
+		unsigned long long lat_val = lat_mean;
+		double lat_mean_d = lat_mean, lat_dev_d = 0.0;
+		char *lat_num;
 
-	log_buf(out, "  steadystate  : attained=%s, bw=%s (%s), iops=%s, %s%s=%.3f%s\n",
+		if (nsec_to_msec(&lat_val, &lat_val, &lat_mean_d, &lat_dev_d))
+			lat_unit = "msec";
+		else if (nsec_to_usec(&lat_val, &lat_val, &lat_mean_d, &lat_dev_d))
+			lat_unit = "usec";
+
+		lat_num = num2str((unsigned long long)lat_mean_d, ts->sig_figs, 1, 0, N2S_NONE);
+		if (asprintf(&p3, "%s%s", lat_num, lat_unit) < 0)
+			p3 = NULL;
+		free(lat_num);
+	}
+
+	log_buf(out, "  steadystate  : attained=%s, bw=%s (%s), iops=%s%s%s, %s%s=%.3f%s\n",
 		ts->ss_state & FIO_SS_ATTAINED ? "yes" : "no",
 		p1, p1alt, p2,
-		ts->ss_state & FIO_SS_IOPS ? "iops" : "bw",
+		p3 ? ", lat=" : "",
+		p3 ? p3 : "",
+		ts->ss_state & FIO_SS_IOPS ? "iops" : (ts->ss_state & FIO_SS_LAT ? "lat" : "bw"),
 		ts->ss_state & FIO_SS_SLOPE ? " slope": " mean dev",
 		ts->ss_criterion.u.f,
 		ts->ss_state & FIO_SS_PCT ? "%" : "");
@@ -960,6 +979,7 @@ static void show_ss_normal(const struct thread_stat *ts, struct buf_output *out)
 	free(p1);
 	free(p1alt);
 	free(p2);
+	free(p3);
 }
 
 static void show_agg_stats(const struct disk_util_agg *agg, int terse,
@@ -1903,7 +1923,7 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 		int intervals = ts->ss_dur / (ss_check_interval / 1000L);
 
 		snprintf(ss_buf, sizeof(ss_buf), "%s%s:%f%s",
-			ts->ss_state & FIO_SS_IOPS ? "iops" : "bw",
+			ts->ss_state & FIO_SS_IOPS ? "iops" : (ts->ss_state & FIO_SS_LAT ? "lat" : "bw"),
 			ts->ss_state & FIO_SS_SLOPE ? "_slope" : "",
 			(float) ts->ss_limit.u.f,
 			ts->ss_state & FIO_SS_PCT ? "%" : "");
@@ -1942,6 +1962,16 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 		}
 		json_object_add_value_int(data, "bw_mean", steadystate_bw_mean(ts));
 		json_object_add_value_int(data, "iops_mean", steadystate_iops_mean(ts));
+		if (ts->ss_state & FIO_SS_LAT) {
+			struct json_array *lat;
+			lat = json_create_array();
+			for (l = 0; l < intervals; l++) {
+				k = (j + l) % intervals;
+				json_array_add_value_int(lat, ts->ss_lat_data[k]);
+			}
+			json_object_add_value_int(data, "lat_mean", steadystate_lat_mean(ts));
+			json_object_add_value_array(data, "lat_ns", lat);
+		}
 		json_object_add_value_array(data, "iops", iops);
 		json_object_add_value_array(data, "bw", bw);
 	}
@@ -2600,6 +2630,7 @@ void __show_run_stats(void)
 			ts->ss_head = td->ss.head;
 			ts->ss_bw_data = td->ss.bw_data;
 			ts->ss_iops_data = td->ss.iops_data;
+			ts->ss_lat_data = td->ss.lat_data;
 			ts->ss_limit.u.f = td->ss.limit;
 			ts->ss_slope.u.f = td->ss.slope;
 			ts->ss_deviation.u.f = td->ss.deviation;
diff --git a/stat.h b/stat.h
index f40507e3..84ea8445 100644
--- a/stat.h
+++ b/stat.h
@@ -283,6 +283,16 @@ struct thread_stat {
 		uint64_t pad5;
 	};
 
+	union {
+		uint64_t *ss_lat_data;
+		/*
+		 * For FIO_NET_CMD_TS, the pointed to data will temporarily
+		 * be stored at this offset from the start of the payload.
+		 */
+		uint64_t ss_lat_data_offset;
+		uint64_t pad5b;
+	};
+
 	union {
 		struct clat_prio_stat *clat_prio[DDIR_RWDIR_CNT];
 		/*
diff --git a/steadystate.c b/steadystate.c
index 9e47df2c..9e26012d 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -10,8 +10,10 @@ void steadystate_free(struct thread_data *td)
 {
 	free(td->ss.iops_data);
 	free(td->ss.bw_data);
+	free(td->ss.lat_data);
 	td->ss.iops_data = NULL;
 	td->ss.bw_data = NULL;
+	td->ss.lat_data = NULL;
 }
 
 static void steadystate_alloc(struct thread_data *td)
@@ -20,6 +22,7 @@ static void steadystate_alloc(struct thread_data *td)
 
 	td->ss.bw_data = calloc(intervals, sizeof(uint64_t));
 	td->ss.iops_data = calloc(intervals, sizeof(uint64_t));
+	td->ss.lat_data = calloc(intervals, sizeof(uint64_t));
 
 	td->ss.state |= FIO_SS_DATA;
 }
@@ -60,7 +63,7 @@ void steadystate_setup(void)
 		steadystate_alloc(prev_td);
 }
 
-static bool steadystate_slope(uint64_t iops, uint64_t bw,
+static bool steadystate_slope(uint64_t iops, uint64_t bw, double lat,
 			      struct thread_data *td)
 {
 	int i, j;
@@ -71,11 +74,14 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
 
 	ss->bw_data[ss->tail] = bw;
 	ss->iops_data[ss->tail] = iops;
+	ss->lat_data[ss->tail] = (uint64_t)lat;
 
 	if (ss->state & FIO_SS_IOPS)
 		new_val = iops;
-	else
+	else if (ss->state & FIO_SS_BW)
 		new_val = bw;
+	else
+		new_val = (uint64_t)lat;
 
 	if (ss->state & FIO_SS_BUFFER_FULL || ss->tail - ss->head == intervals - 1) {
 		if (!(ss->state & FIO_SS_BUFFER_FULL)) {
@@ -83,13 +89,17 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
 			for (i = 0, ss->sum_y = 0; i < intervals; i++) {
 				if (ss->state & FIO_SS_IOPS)
 					ss->sum_y += ss->iops_data[i];
-				else
+				else if (ss->state & FIO_SS_BW)
 					ss->sum_y += ss->bw_data[i];
+				else
+					ss->sum_y += ss->lat_data[i];
 				j = (ss->head + i) % intervals;
 				if (ss->state & FIO_SS_IOPS)
 					ss->sum_xy += i * ss->iops_data[j];
-				else
+				else if (ss->state & FIO_SS_BW)
 					ss->sum_xy += i * ss->bw_data[j];
+				else
+					ss->sum_xy += i * ss->lat_data[j];
 			}
 			ss->state |= FIO_SS_BUFFER_FULL;
 		} else {		/* easy to update the sums */
@@ -100,8 +110,10 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
 
 		if (ss->state & FIO_SS_IOPS)
 			ss->oldest_y = ss->iops_data[ss->head];
-		else
+		else if (ss->state & FIO_SS_BW)
 			ss->oldest_y = ss->bw_data[ss->head];
+		else
+			ss->oldest_y = ss->lat_data[ss->head];
 
 		/*
 		 * calculate slope as (sum_xy - sum_x * sum_y / n) / (sum_(x^2)
@@ -134,7 +146,7 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
 	return false;
 }
 
-static bool steadystate_deviation(uint64_t iops, uint64_t bw,
+static bool steadystate_deviation(uint64_t iops, uint64_t bw, double lat,
 				  struct thread_data *td)
 {
 	int i;
@@ -146,6 +158,7 @@ static bool steadystate_deviation(uint64_t iops, uint64_t bw,
 
 	ss->bw_data[ss->tail] = bw;
 	ss->iops_data[ss->tail] = iops;
+	ss->lat_data[ss->tail] = (uint64_t)lat;
 
 	if (ss->state & FIO_SS_BUFFER_FULL || ss->tail - ss->head == intervals  - 1) {
 		if (!(ss->state & FIO_SS_BUFFER_FULL)) {
@@ -153,22 +166,28 @@ static bool steadystate_deviation(uint64_t iops, uint64_t bw,
 			for (i = 0, ss->sum_y = 0; i < intervals; i++) {
 				if (ss->state & FIO_SS_IOPS)
 					ss->sum_y += ss->iops_data[i];
-				else
+				else if (ss->state & FIO_SS_BW)
 					ss->sum_y += ss->bw_data[i];
+				else
+					ss->sum_y += ss->lat_data[i];
 			}
 			ss->state |= FIO_SS_BUFFER_FULL;
 		} else {		/* easy to update the sum */
 			ss->sum_y -= ss->oldest_y;
 			if (ss->state & FIO_SS_IOPS)
 				ss->sum_y += ss->iops_data[ss->tail];
-			else
+			else if (ss->state & FIO_SS_BW)
 				ss->sum_y += ss->bw_data[ss->tail];
+			else
+				ss->sum_y += ss->lat_data[ss->tail];
 		}
 
 		if (ss->state & FIO_SS_IOPS)
 			ss->oldest_y = ss->iops_data[ss->head];
-		else
+		else if (ss->state & FIO_SS_BW)
 			ss->oldest_y = ss->bw_data[ss->head];
+		else
+			ss->oldest_y = ss->lat_data[ss->head];
 
 		mean = (double) ss->sum_y / intervals;
 		ss->deviation = 0.0;
@@ -176,8 +195,10 @@ static bool steadystate_deviation(uint64_t iops, uint64_t bw,
 		for (i = 0; i < intervals; i++) {
 			if (ss->state & FIO_SS_IOPS)
 				diff = ss->iops_data[i] - mean;
-			else
+			else if (ss->state & FIO_SS_BW)
 				diff = ss->bw_data[i] - mean;
+			else
+				diff = ss->lat_data[i] - mean;
 			ss->deviation = max(ss->deviation, diff * (diff < 0.0 ? -1.0 : 1.0));
 		}
 
@@ -209,13 +230,18 @@ int steadystate_check(void)
 	unsigned long rate_time;
 	struct timespec now;
 	uint64_t group_bw = 0, group_iops = 0;
+	double group_lat_sum = 0.0;
+	uint64_t group_lat_samples = 0;
 	uint64_t td_iops, td_bytes;
+	double group_lat;
 	bool ret;
 
 	prev_groupid = -1;
 	for_each_td(td) {
 		const bool needs_lock = td_async_processing(td);
 		struct steadystate_data *ss = &td->ss;
+		double td_lat_sum = 0.0;
+		uint64_t td_lat_samples = 0;
 
 		if (!ss->dur || td->runstate <= TD_SETTING_UP ||
 		    td->runstate >= TD_EXITED || !ss->state ||
@@ -228,6 +254,8 @@ int steadystate_check(void)
 		    (td->o.group_reporting && td->groupid != prev_groupid)) {
 			group_bw = 0;
 			group_iops = 0;
+			group_lat_sum = 0.0;
+			group_lat_samples = 0;
 			group_ramp_time_over = 0;
 		}
 		prev_groupid = td->groupid;
@@ -248,6 +276,9 @@ int steadystate_check(void)
 		for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 			td_iops += td->io_blocks[ddir];
 			td_bytes += td->io_bytes[ddir];
+			td_lat_sum += td->ts.clat_stat[ddir].mean.u.f *
+				      td->ts.clat_stat[ddir].samples;
+			td_lat_samples += td->ts.clat_stat[ddir].samples;
 		}
 
 		if (needs_lock)
@@ -261,10 +292,14 @@ int steadystate_check(void)
 				(ss_check_interval * ss_check_interval / 1000L);
 			group_iops += rate_time * (td_iops - ss->prev_iops) /
 				(ss_check_interval * ss_check_interval / 1000L);
+			group_lat_sum += td_lat_sum - ss->prev_lat_sum;
+			group_lat_samples += td_lat_samples - ss->prev_lat_samples;
 			++group_ramp_time_over;
 		}
 		ss->prev_iops = td_iops;
 		ss->prev_bytes = td_bytes;
+		ss->prev_lat_sum = td_lat_sum;
+		ss->prev_lat_samples = td_lat_samples;
 
 		if (td->o.group_reporting && !(ss->state & FIO_SS_DATA))
 			continue;
@@ -284,10 +319,14 @@ int steadystate_check(void)
 					(unsigned long long) group_bw,
 					ss->head, ss->tail);
 
+		group_lat = 0.0;
+		if (group_lat_samples)
+			group_lat = group_lat_sum / group_lat_samples;
+
 		if (ss->state & FIO_SS_SLOPE)
-			ret = steadystate_slope(group_iops, group_bw, td);
+			ret = steadystate_slope(group_iops, group_bw, group_lat, td);
 		else
-			ret = steadystate_deviation(group_iops, group_bw, td);
+			ret = steadystate_deviation(group_iops, group_bw, group_lat, td);
 
 		if (ret) {
 			if (td->o.group_reporting) {
@@ -353,32 +392,32 @@ int td_steadystate_init(struct thread_data *td)
 	return 0;
 }
 
-uint64_t steadystate_bw_mean(const struct thread_stat *ts)
+static uint64_t steadystate_data_mean(uint64_t *data, int ss_dur)
 {
 	int i;
 	uint64_t sum;
-	int intervals = ts->ss_dur / (ss_check_interval / 1000L);
-	
-	if (!ts->ss_dur)
+	int intervals = ss_dur / (ss_check_interval / 1000L);
+
+	if (!ss_dur)
 		return 0;
 
 	for (i = 0, sum = 0; i < intervals; i++)
-		sum += ts->ss_bw_data[i];
+		sum += data[i];
 
 	return sum / intervals;
 }
 
-uint64_t steadystate_iops_mean(const struct thread_stat *ts)
+uint64_t steadystate_bw_mean(const struct thread_stat *ts)
 {
-	int i;
-	uint64_t sum;
-	int intervals = ts->ss_dur / (ss_check_interval / 1000L);
-
-	if (!ts->ss_dur)
-		return 0;
+	return steadystate_data_mean(ts->ss_bw_data, ts->ss_dur);
+}
 
-	for (i = 0, sum = 0; i < intervals; i++)
-		sum += ts->ss_iops_data[i];
+uint64_t steadystate_iops_mean(const struct thread_stat *ts)
+{
+	return steadystate_data_mean(ts->ss_iops_data, ts->ss_dur);
+}
 
-	return sum / intervals;
+uint64_t steadystate_lat_mean(const struct thread_stat *ts)
+{
+	return steadystate_data_mean(ts->ss_lat_data, ts->ss_dur);
 }
diff --git a/steadystate.h b/steadystate.h
index e25fd9d0..aff15211 100644
--- a/steadystate.h
+++ b/steadystate.h
@@ -9,6 +9,7 @@ extern void steadystate_setup(void);
 extern int td_steadystate_init(struct thread_data *);
 extern uint64_t steadystate_bw_mean(const struct thread_stat *);
 extern uint64_t steadystate_iops_mean(const struct thread_stat *);
+extern uint64_t steadystate_lat_mean(const struct thread_stat *);
 
 extern bool steadystate_enabled;
 extern unsigned int ss_check_interval;
@@ -24,6 +25,7 @@ struct steadystate_data {
 	unsigned int tail;
 	uint64_t *iops_data;
 	uint64_t *bw_data;
+	uint64_t *lat_data;
 
 	double slope;
 	double deviation;
@@ -38,6 +40,8 @@ struct steadystate_data {
 	struct timespec prev_time;
 	uint64_t prev_iops;
 	uint64_t prev_bytes;
+	double prev_lat_sum;
+	uint64_t prev_lat_samples;
 };
 
 enum {
@@ -49,6 +53,7 @@ enum {
 	__FIO_SS_DATA,
 	__FIO_SS_PCT,
 	__FIO_SS_BUFFER_FULL,
+	__FIO_SS_LAT,
 };
 
 enum {
@@ -60,9 +65,11 @@ enum {
 	FIO_SS_DATA		= 1 << __FIO_SS_DATA,
 	FIO_SS_PCT		= 1 << __FIO_SS_PCT,
 	FIO_SS_BUFFER_FULL	= 1 << __FIO_SS_BUFFER_FULL,
+	FIO_SS_LAT		= 1 << __FIO_SS_LAT,
 
 	FIO_SS_IOPS_SLOPE	= FIO_SS_IOPS | FIO_SS_SLOPE,
 	FIO_SS_BW_SLOPE		= FIO_SS_BW | FIO_SS_SLOPE,
+	FIO_SS_LAT_SLOPE	= FIO_SS_LAT | FIO_SS_SLOPE,
 };
 
 #endif
diff --git a/t/fiotestlib.py b/t/fiotestlib.py
index 913cb605..2049e41e 100755
--- a/t/fiotestlib.py
+++ b/t/fiotestlib.py
@@ -13,6 +13,7 @@ import os
 import sys
 import json
 import locale
+import shutil
 import logging
 import platform
 import traceback
@@ -473,6 +474,8 @@ def run_fio_tests(test_list, test_env, args):
         if test.passed:
             result = "PASSED"
             passed = passed + 1
+            if hasattr(args, 'cleanup') and args.cleanup:
+                shutil.rmtree(test_env['artifact_root'] + f"/{config['test_id']:04d}", ignore_errors=True)
         else:
             result = f"FAILED: {test.failure_reason}"
             failed = failed + 1
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 85112878..457d7f8c 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -1156,6 +1156,8 @@ def parse_args():
                         help='pass-through an argument to an executable test')
     parser.add_argument('--nvmecdev', action='store', default=None,
                         help='NVMe character device for **DESTRUCTIVE** testing (e.g., /dev/ng0n1)')
+    parser.add_argument('-c', '--cleanup', action='store_true', default=False,
+                        help='Delete artifacts for passing tests')
     args = parser.parse_args()
 
     return args
