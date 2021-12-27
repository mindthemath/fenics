#!/bin/bash
BUSTER_ONLY="3.6.9-buster 3.6.10-buster 3.6.11-buster 3.6.12-buster 3.6.13-buster 3.7.4-buster 3.7.5-buster 3.7.6-buster 3.7.7-buster 3.7.8-buster 3.7.9-buster 3.7.10-buster 3.8.4-buster 3.8.5-buster 3.8.6-buster 3.8.7-buster 3.8.8-buster 3.8.9-buster 3.8.10-buster"
BOTH="3.6.14-buster 3.6.14-bullseye 3.6.15-buster 3.6.15-bullseye 3.7.11-buster 3.7.11-bullseye 3.7.12-buster 3.7.12-bullseye 3.8.11-buster 3.8.11-bullseye 3.8.12-buster 3.8.12-bullseye 3.9.6-buster 3.9.6-bullseye 3.9.7-buster 3.9.7-bullseye 3.9.8-buster 3.9.8-bullseye 3.9.9-buster 3.9.9-bullseye 3.10.0-buster 3.10.0-bullseye 3.10.1-buster 3.10.1-bullseye"
ORG=mindthemath
REPO=fenics
BASE=$ORG/$REPO
PYTHON_TAG="3.9.6-bullseye"
# IMAGE=$BASE:$FENICS_VERSION-$PYTHON_TAG
FENICS_VERSION="2019.2.0.dev0"

for FENICS_VERSION in `echo 2019.2.0.dev0 2019.1.0 2019.1.0.post0`; do

for PYTHON_TAG in `echo $BUSTER_ONLY $BOTH | sort`; do

IMAGE=$BASE:$FENICS_VERSION-$PYTHON_TAG
ARM_IMAGE=$BASE-arm64:$FENICS_VERSION-$PYTHON_TAG
AMD_IMAGE=$BASE-amd64:$FENICS_VERSION-$PYTHON_TAG
echo "docker manifest rm" $IMAGE
echo "docker manifest create" $IMAGE $ARM_IMAGE $AMD_IMAGE
echo "docker manifest push" $IMAGE
done

# the bottom is just creating tags. at this point manifests have been taken care of in canonical form.
# want to create equivalent tags + publish them.
echo ""

# when both buster and bullseye are available
for PYTHON_TAG in `echo $BOTH | sort`; do
IMAGE=$BASE:$FENICS_VERSION-$PYTHON_TAG
if [[ "$PYTHON_TAG" == *"bullseye" ]]; then
  NEWTAG=`echo $PYTHON_TAG | sed 's|-bullseye||g'`
  if [[ "$FENICS_VERSION" == *"dev0" ]]; then
    echo "docker tag" $IMAGE $BASE:$FENICS_VERSION-$NEWTAG
    echo "docker tag" $IMAGE $BASE:$NEWTAG
    echo "docker push" $BASE:$FENICS_VERSION-$NEWTAG
    echo "docker push" $BASE:$NEWTAG
  else
    echo "docker tag" $IMAGE $BASE:$FENICS_VERSION-$NEWTAG
    echo "docker push" $BASE:$FENICS_VERSION-$NEWTAG
  fi
fi
done

echo ""

# when only buster is available
for PYTHON_TAG in `echo $BUSTER_ONLY | sort`; do
  IMAGE=$BASE:$FENICS_VERSION-$PYTHON_TAG
  NEWTAG=`echo $PYTHON_TAG | sed 's|-buster||g'`
  if [[ "$FENICS_VERSION" == *"dev0" ]]; then
    echo "docker tag" $IMAGE $BASE:$FENICS_VERSION-$NEWTAG
    echo "docker tag" $IMAGE $BASE:$NEWTAG
    echo "docker push" $BASE:$FENICS_VERSION-$NEWTAG
    echo "docker push" $BASE:$NEWTAG
  else
    echo "docker tag" $IMAGE $BASE:$FENICS_VERSION-$NEWTAG
    echo "docker push" $BASE:$FENICS_VERSION-$NEWTAG
  fi
done

echo ""
echo ""
done
