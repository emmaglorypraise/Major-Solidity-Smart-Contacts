// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

  /// @title  ToDo contract 
  /// @author Glory Praise Emmanuel
  /// @dev A contract that creates, updates, views, completes and deletes tasks


contract ToDo {
  uint taskCount;

  struct Task {
    string text;
    string category;
    bool completed;
  }

  mapping(uint => Task) todo;

  Task[] todos;

  function viewTask(uint _id) public view returns(string memory _text, string memory _category, bool _completed){
   _text =  todo[_id].text;
   _category =  todo[_id].category;
   _completed = todo[_id].completed;
  }

  function createTask(uint _id, string memory _text, string memory _category) public {
    todo[_id].text = _text;
    todo[_id].category = _category;
    todo[_id].completed = false;
    todos.push(todo[_id]);
    taskCount++;
  }

  function updateTask(uint _id, string memory _text, string memory _category) public {
    todo[_id].text = _text;
    todo[_id].category = _category;
    todo[_id].completed = false;
  }

  function completeTask(uint _id) public {
    todo[_id].completed = true;
  }

   function deleteTask(uint _id) public {
    delete todo[_id];
  }
}