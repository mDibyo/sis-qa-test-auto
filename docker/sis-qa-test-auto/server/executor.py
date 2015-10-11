#!/usr/bin/env python3

import subprocess
import os.path as osp
import os
import json
from collections import Counter

__author__ = "Dibyo Majumdar"
__email__ = "dibyo.majumdar@gmail.com"

LOGS_DIR = osp.abspath(os.environ['SIS_LOGS_DIR'])


class TestResult:
    ERRORED = -1
    COMPLETED = 0
    QUEUED = 1
    DRYRUN = 2
    RUNNING = 3

    class TestStep:
        symbol_result_map = {
            '.': 'passed',
            'F': 'failed',
            '-': 'skipped',
        }

        def __init__(self, result: 'TestResult', step: dict):
            self._test_results = result
            self._step = step

        def set_result(self, symbol: str):
            result = self.symbol_result_map[symbol]
            self._step['result']['status'] = result
            self._test_results.update_counters(result)

    def __init__(self, status=None):
        self.status = status if status is not None else self.QUEUED
        self.data = None
        self.counters = Counter()

    def iterator(self):
        if self.data is None:
            return

        for test_file in self.data:
            for test_scenario in test_file['elements']:
                for test_step in test_scenario['steps']:
                    yield TestResult.TestStep(self, test_step)

    def update_counters(self, curr_result: str):
        self.counters[curr_result] += 1
        self.counters['completed'] += 1


CUCUMBER_DRYRUN_CMD = 'bundle exec cucumber -d -f json'
CUCUMBER_EXECUTION_CMD = 'bundle exec cucumber -f json -o {output}' \
                         ' -f progress'

def execute_tests(uid: str, test_result: TestResult):
    try:
        # dryrun
        test_result.status = TestResult.DRYRUN
        dryrun = subprocess.Popen(CUCUMBER_DRYRUN_CMD.split(),
                                  stdout=subprocess.PIPE)
        json_data =  dryrun.stdout.read().decode('utf-8')
        test_result.data = json.loads(json_data)

        # execution
        test_result.status = TestResult.RUNNING
        logs_output = osp.join(LOGS_DIR, uid)
        subprocess.check_call('mkdir -p {}'.format(logs_output).split())
        execution = subprocess.Popen(
            CUCUMBER_EXECUTION_CMD.format(output=os.path.join(logs_output, 'results.json')).split(),
            stdout=subprocess.PIPE)
        for test_step in test_result.iterator():
            symbol = execution.stdout.read1(1).decode('utf-8')
            test_step.set_result(symbol)

        test_result.status = TestResult.COMPLETED
    except subprocess.SubprocessError as error:
        test_result.status = TestResult.ERRORED
        test_result.data = error
