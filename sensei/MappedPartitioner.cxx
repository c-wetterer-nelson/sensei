#include "MappedPartitioner.h"
#include "XMLUtils.h"

#include <pugixml.hpp>


namespace sensei
{

// --------------------------------------------------------------------------
MappedPartitioner::MappedPartitioner(const std::vector<int> &blkOwner,
  const std::vector<int> &blkIds) : BlockOwner(blkOwner), BlockIds(blkIds)
{
}

// --------------------------------------------------------------------------
void MappedPartitioner::SetBlockOwner(const std::vector<int> &blkOwner)
{
  this->BlockOwner = blkOwner;
}

// --------------------------------------------------------------------------
void MappedPartitioner::SetBlockIds(const std::vector<int> &blkIds)
{
  this->BlockIds = blkIds;
}

// --------------------------------------------------------------------------
int MappedPartitioner::GetPartition(MPI_Comm comm, const MeshMetadataPtr &mdIn,
  MeshMetadataPtr &mdOut)
{
  (void)comm;

  mdOut = mdIn->NewCopy();

  mdOut->BlockOwner = this->BlockOwner;
  mdOut->BlockIds = this->BlockIds;

  return 0;
}

// --------------------------------------------------------------------------
int MappedPartitioner::Initialize(pugi::xml_node &node)
{
  if (XMLUtils::RequireChild(node, "block_owner") || 
    XMLUtils::RequireChild(node, "block_id"))
    return -1;

  std::string blkOwnerElem = node.child("block_owner").text().as_string();
  std::string blkIdsElem = node.child("block_id").text().as_string();

  std::string delims = " \t";

  std::size_t curr = blkOwnerElem.find_first_not_of(delims, 0);
  std::size_t next = std::string::npos;

  while (curr != std::string::npos)
    {
    next = blkOwnerElem.find_first_of(delims, curr + 1);
    this->BlockOwner.push_back(std::stoi(blkOwnerElem.substr(curr, next - curr)));
    curr = blkOwnerElem.find_first_not_of(delims, next);
    }

  curr = blkIdsElem.find_first_not_of(delims, 0);

  while (curr != std::string::npos)
    {
    next = blkIdsElem.find_first_of(delims, curr + 1);
    this->BlockIds.push_back(std::stoi(blkIdsElem.substr(curr, next - curr)));
    curr = blkIdsElem.find_first_not_of(delims, next);
    }

  return 0;
}

}