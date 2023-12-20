// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Todo {
    struct TodoItem {
        address owner;
        string task;
        bool complete;
    }

    mapping(uint256 => TodoItem) public todoList;
    uint256 public todoCount;

    event TaskCreated(
        uint256 taskId,
        address owner,
        string task,
        bool complete
    );
    event TaskDeleted(uint256 taskId);
    event TaskUpdated(uint256 taskId, string newTask);
    event TaskCompleted(uint256 taskId);

    modifier onlyTaskOwner(uint256 _taskId) {
        require(
            todoList[_taskId].owner == msg.sender,
            "Not the owner of the task"
        );
        _;
    }

    function createTask(string memory _task) public {
        uint256 taskId = todoCount++;
        todoList[taskId] = TodoItem(msg.sender, _task, false);
        emit TaskCreated(taskId, msg.sender, _task, false);
    }

    function deleteTask(uint256 _taskId) public onlyTaskOwner(_taskId) {
        delete todoList[_taskId];
        emit TaskDeleted(_taskId);
    }

    function updateTask(
        uint256 _taskId,
        string memory _newTask
    ) public onlyTaskOwner(_taskId) {
        todoList[_taskId].task = _newTask;
        emit TaskUpdated(_taskId, _newTask);
    }

    function markAsComplete(uint256 _taskId) public onlyTaskOwner(_taskId) {
        todoList[_taskId].complete = true;
        emit TaskCompleted(_taskId);
    }
}
