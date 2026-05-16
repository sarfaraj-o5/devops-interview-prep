## shared Library (resuable logic)
@Library('shared-pipeline-lib')_
pipeline {
    agent any
    stages {
        stage('Build'){steps {common.buildMaven() }}
        stage('Test'){steps {common.runTest() }}
        stage('Deploy'){steps {common.deployHem('prod') }}
    }
}